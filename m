Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXJBXco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXJBXco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbXJBXcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:32:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753124AbXJBXcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:32:35 -0400
Date: Tue, 2 Oct 2007 16:32:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23-rc9 and a heads-up for the 2.6.24 series..
In-Reply-To: <20071003010730.2fb7ec5c.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.999.0710021630560.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003010730.2fb7ec5c.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Diego Calleja wrote:
> 
> Also...if someone dislikes something in http://kernelnewbies.org/Linux_2_6_23 ,
> or wants to fix my english, do it soon :)

Heh. The "remove sk98lin driver" bullet is sadly wrong. We had to 
reinstate it because it supported some cards that the skge driver doesn't 
handle.

		Linus
