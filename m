Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYBIWCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYBIWCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 17:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYBIWBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 17:01:46 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39647 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbYBIWBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 17:01:45 -0500
Date: Sat, 9 Feb 2008 23:01:44 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: One minute delay when booting 2.6.24.1
In-Reply-To: <200802091329.35851.tvrtko@ursulin.net>
Message-ID: <Pine.LNX.4.64.0802092301180.6917@fbirervta.pbzchgretzou.qr>
References: <200802091329.35851.tvrtko@ursulin.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 9 2008 13:29, Tvrtko A. Ursulin wrote:
>Hi all,
>
>As the subject says I get ~1 minute delay when booting 2.6.24.1
>pretty reliably. It is possible it is not new to 2.6.24.1 but I
>can't tell due recent hardware changes.
>
>dmesg excerpt where it happens looks like this (full one attached):

Do you really experience a 1 minute wait, or is this perhaps
just the clock skipping?

