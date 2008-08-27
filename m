Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbYH0MgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbYH0MgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 08:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbYH0Mfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 08:35:53 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:51747 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYH0Mfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 08:35:52 -0400
Date: Wed, 27 Aug 2008 21:35:51 +0900 (JST)
Message-Id: <20080827.213551.72707274.anemo@mba.ocn.ne.jp>
To: sfalco@harris.com
Cc: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       will.newton@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <48B4159A.9070907@harris.com>
References: <87a5b0800808260700g52cedf59kb07880ae05a104b@mail.gmail.com>
	<20080826161353.6326f6e2@i1501.lan.towertech.it>
	<48B4159A.9070907@harris.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2008 10:39:22 -0400, "Steven A. Falco" <sfalco@harris.com> wrote:
> >  Given the small amount of changes, I would use the existing driver without
> >  renaming it.
> > 
> 
> Sounds good.  Please let me know if there are other changes needed to make this
> patch acceptable for inclusion into the mainline.

It would be better adding the chip name to the Kconfig help text as well.

---
Atsushi Nemoto
