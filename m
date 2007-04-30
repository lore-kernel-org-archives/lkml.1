Return-Path: <linux-kernel-owner+w=401wt.eu-S1946788AbXD3UhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946788AbXD3UhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946801AbXD3UhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:37:22 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3057 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946788AbXD3UhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:37:20 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] [39/40] i386: Export paravirt_ops for non GPL modulestoo
Date: Mon, 30 Apr 2007 13:37:15 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKOECCDHAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <1177936139.4843.17.camel@lappy>
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 30 Apr 2007 14:37:34 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 30 Apr 2007 14:37:36 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> FWIW I think doing this first will be better, exposing _all_ to non GNU
> modules will weaken whatever case we might have to take it away later.

> So, NACK from me too.

> I don't want to hear the whining; but it was allowed in .22, so why
> should we not be able to do this in .23.... or whatever.

This is the most illogical and perverse argument I think I have *ever* seen
on this mailing list, and that's saying something.

If people find legitimate uses for it while it's available, that's a proof
that taking it away is wrong. Symbols are supposed to be marked GPL if and
only if it's not possible to use them in non-GPL'd works. So, yeah, let's
not risk letting people prove your position is wrong before you have a
chance to enforce it.

DS


