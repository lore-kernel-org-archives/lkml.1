Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbXITGQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbXITGQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbXITGQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:16:33 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2798 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbXITGQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:16:32 -0400
Date: Thu, 20 Sep 2007 08:16:11 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/video/pmag-ba-fb.c: Improve diagnostics
Message-ID: <20070920061611.GE23757@deprecation.cyrius.com>
References: <Pine.LNX.4.64N.0709171736580.17606@blysk.ds.pg.gda.pl> <Pine.LNX.4.64N.0709181314300.9650@blysk.ds.pg.gda.pl> <20070919172412.725508d0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919172412.725508d0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2007-09-19 17:24]:
> I made that change, but am too stupid to be able to work out how to create
> a config which will let me compile this thing.
> 
> akpm:/usr/src/25> grep PMAG arch/arm/configs/*
> akpm:/usr/src/25> 

It's a driver for mips.
-- 
Martin Michlmayr
http://www.cyrius.com/
