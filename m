Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbXFKSUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbXFKSUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 14:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbXFKST7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 14:19:59 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:25332 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXFKST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 14:19:58 -0400
Date: Mon, 11 Jun 2007 20:19:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
In-Reply-To: <466D882D.70001@zytor.com>
Message-ID: <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky>
 <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com>
 <466D882D.70001@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 11 2007 10:36, H. Peter Anvin wrote:
>
>Picking the 16 MB base is a bit obnoxious on small-memory machines, 4 MB
>would probably be a more reasonable base.  Of course, 16 MB would avoid
>  the issue of the handful of machines with memory holes at 15-16 MB.

How will this work at all with a 5 MB machine?



	Jan
-- 
