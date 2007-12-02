Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbXLBTuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbXLBTuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755117AbXLBTtw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:49:52 -0500
Received: from lazybastard.de ([212.112.238.170]:49023 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbXLBTtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:49:51 -0500
Date: Sun, 2 Dec 2007 20:44:30 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Avi Kivity <avi@argo.co.il>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Kernel Development & Objective-C
Message-ID: <20071202194429.GA10657@lazybastard.org>
References: <474EAD18.6040408@stellatravel.co.uk> <20071130143445.GA2310@csclub.uwaterloo.ca> <4751BD23.7020104@argo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4751BD23.7020104@argo.co.il>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 December 2007 21:59:31 +0200, Avi Kivity wrote:
> 
> Object orientation in C leaves much to be desired; see the huge number 
> of void pointers and container_of()s in the kernel.

While true, this isn't such a bad problem.  A language really sucks when
it tries to disallow something useful.  Back in university I was forced
to write system software in pascal.  Simple pointer arithmetic became a
5-line piece of code.

Imo the main advantage of C is simply that it doesn't get in the way.

Jörn

-- 
But this is not to say that the main benefit of Linux and other GPL
software is lower-cost. Control is the main benefit--cost is secondary.
-- Bruce Perens
