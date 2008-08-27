Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbYH0Q0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbYH0Q0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbYH0QZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:25:40 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62883 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759152AbYH0QZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:25:38 -0400
Date: Wed, 27 Aug 2008 17:25:03 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
cc: sfalco@harris.com, alessandro.zummo@towertech.it,
       rtc-linux@googlegroups.com, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
In-Reply-To: <20080827.225323.118975574.anemo@mba.ocn.ne.jp>
Message-ID: <Pine.LNX.4.55.0808271717110.5930@cliff.in.clinika.pl>
References: <48B4159A.9070907@harris.com> <20080827.213551.72707274.anemo@mba.ocn.ne.jp>
 <48B55788.5050306@harris.com> <20080827.225323.118975574.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Atsushi Nemoto wrote:

> > Ok - here is a respin with the Kconfig modded to indicate support for
> > the M41T65.
> 
> Thanks, looks fine for me.

 Not for me though -- the names should be sorted alphabetically as this is
how the reader will look for the right one (assuming they do not get fed
up and resort to `grep').  There is virtually no chance to notice this one 
among the plethora of chip variations supported.

  Maciej
