Return-Path: <linux-kernel-owner+w=401wt.eu-S1760173AbZFOKL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760173AbZFOKL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 06:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757817AbZFOKLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 06:11:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59094
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760048AbZFOKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 06:11:15 -0400
Date: Mon, 15 Jun 2009 03:11:18 -0700 (PDT)
Message-Id: <20090615.031118.39013273.davem@davemloft.net>
To: tiwai@suse.de
Cc: bzolnier@gmail.com, sven.koehler@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5htz2hes3u.wl%tiwai@suse.de>
References: <20090615.022547.107684868.davem@davemloft.net>
	<s5hy6rtesjo.wl%tiwai@suse.de>
	<s5htz2hes3u.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 15 Jun 2009 11:58:13 +0200

> Damn, that was buggy again.  The fixed version is below.

This seems to fix the bug and work fine.

Thanks!
