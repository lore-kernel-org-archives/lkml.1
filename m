Return-Path: <linux-kernel-owner+w=401wt.eu-S1762224AbXKMWgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224AbXKMWgI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759409AbXKMWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:35:56 -0500
Received: from lazybastard.de ([212.112.238.170]:54692 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbXKMWfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:35:55 -0500
Date: Tue, 13 Nov 2007 23:30:53 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Ray Lee <ray-lk@madrabbit.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Andi Kleen <ak@suse.de>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: x86_64: Make sparsemem/vmemmap the default memory model
Message-ID: <20071113223052.GE20167@lazybastard.org>
References: <Pine.LNX.4.64.0711121549370.29178@schroedinger.engr.sgi.com> <200711130059.34346.ak@suse.de> <Pine.LNX.4.64.0711121615120.29328@schroedinger.engr.sgi.com> <200711130149.54852.ak@suse.de> <Pine.LNX.4.64.0711121940410.30269@schroedinger.engr.sgi.com> <2c0942db0711122027m5b11502cveded5705c0bc4f64@mail.gmail.com> <Pine.LNX.4.64.0711122040380.30724@schroedinger.engr.sgi.com> <20071113204100.GB20167@lazybastard.org> <Pine.LNX.4.64.0711131349300.3714@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0711131349300.3714@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 November 2007 13:52:17 -0800, Christoph Lameter wrote:
> 
> Could you run your own test to verify?

You bastard!  You know I'm too lazy to do that. ;)

As long as the order-0 number is stable across multiple runs I don't
mind.  The numbers just looked suspiciously as if they were not stable.
That's all.

Jörn

-- 
Why do musicians compose symphonies and poets write poems?
They do it because life wouldn't have any meaning for them if they didn't.
That's why I draw cartoons.  It's my life.
-- Charles Shultz
