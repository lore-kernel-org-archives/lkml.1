Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXBEOZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXBEOZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932856AbXBEOZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:25:54 -0500
Received: from mout0.freenet.de ([194.97.50.131]:34862 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854AbXBEOZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:25:52 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: v2.6.20-rt1, yum/rpm
Date: Mon, 5 Feb 2007 15:25:49 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
References: <20070205065636.GA1652@elte.hu>
In-Reply-To: <20070205065636.GA1652@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702051525.49465.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 5. Februar 2007 07:56 schrieb Ingo Molnar:
> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 

after resuming from
	$ echo mem > /sys/power/state
both lapic and pic are active, while only lapic should be.
resuming from
	$ echo disk > /sys/power/state
is fine.

      Karsten
