Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbYKMIic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbYKMIic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 03:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKMIiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 03:38:24 -0500
Received: from mail4.iitk.ac.in ([203.197.196.4]:43516 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbYKMIiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 03:38:23 -0500
X-Greylist: delayed 656 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2008 03:38:23 EST
Date: Thu, 13 Nov 2008 14:34:06 +0000
From: Rahul Pydimukkala <prahul@cse.iitk.ac.in>
To: kyle <kylewong@southa.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: apache threads not balanced over all CPU cores, schedular problem or apache?
Message-ID: <20081113143404.GC12750@csews22.cse.iitk.ac.in>
References: <009401c9454c$6e3a8610$b902a8c0@kyle>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009401c9454c$6e3a8610$b902a8c0@kyle>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12:58 Thu 13 Nov     , kyle wrote:
> Hi,
> 
> Please cc me if possible.
> 
> I have a machine with Intel Q9300 4-core CPU, 8GB RAM. It runs apache 2.0.63
> with traditional prefork MPM.

Yes, this is quite undesirable given that the kernel has a good load-balancer.  Can you give more information regarding the kernel version and load stats of individual apache processes as well?




-
Rahul   

