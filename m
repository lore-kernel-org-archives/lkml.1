Return-Path: <linux-kernel-owner+w=401wt.eu-S1753067AbXFOLMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbXFOLMS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 07:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbXFOLMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 07:12:09 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:7614 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXFOLMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 07:12:07 -0400
Date: Fri, 15 Jun 2007 13:12:05 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
In-Reply-To: <466DB5B8.80005@zytor.com>
Message-ID: <Pine.LNX.4.64.0706151311520.32724@fbirervta.pbzchgretzou.qr>
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky>
 <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com>
 <466D882D.70001@zytor.com> <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr>
 <466D9C00.6030608@zytor.com> <Pine.LNX.4.64.0706112239080.19578@fbirervta.pbzchgretzou.qr>
 <466DB5B8.80005@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 11 2007 13:51, H. Peter Anvin wrote:
>Jan Engelhardt wrote:
>> (yay, 3.09 bogomips and a totally incapable processor :p)
>> Have not tried more recent kernels yet though.
>
>Too bad I don't still have access to the 0.59 bogomips "double sigma"
>386 machine that had the dubious honor of being the slowest Linux
>machine in the world for quite a while.  That machine had 3 MB of RAM.
>
>However, to tie it back to the original discussion, these
>extremely-low-memory machines need nonstandard kernel options anyay.

Not really. Want a .config?


	Jan
-- 
