Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXC3QdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXC3QdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 12:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXC3QdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 12:33:17 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:34704 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753893AbXC3QdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 12:33:17 -0400
Date: Fri, 30 Mar 2007 12:33:16 -0400
To: David Schwartz <davids@webmaster.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Message-ID: <20070330163316.GB3510@csclub.uwaterloo.ca>
References: <460BF73C.5070707@cfl.rr.com> <MDEHLPKNGKAHNMBLJOLKKEAICKAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKKEAICKAC.davids@webmaster.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 02:47:20PM -0700, David Schwartz wrote:
> Which sounds faster to you:
> 
> 1) "Do A, B, C, and D."
>    "Okay, I've finished A, B, C, and B."
> or
> 
> 2) "Do A."
>    "Okay." 
>    "Do B."
>    "Okay."
>    "Do C."
>    "Okay."
>    "Do D."
>    "Okay."
> 
> The first looks a bit more efficient to me.

It also looks like the first one got confused by having to remember all
those letters it had done. :)

--
Len Sorensen
