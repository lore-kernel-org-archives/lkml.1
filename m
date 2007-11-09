Return-Path: <linux-kernel-owner+w=401wt.eu-S1759416AbXKILrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416AbXKILrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXKILrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:47:33 -0500
Received: from smtp2f.orange.fr ([80.12.242.152]:19256 "EHLO smtp2f.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbXKILrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:47:32 -0500
X-ME-UUID: 20071109114730780.BE6EF700009F@mwinf2f23.orange.fr
Date: Fri, 9 Nov 2007 12:42:47 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robert Fitzsimons <robfitz@273k.net>, linux-kernel@vger.kernel.org,
       jblunck@suse.de, ak@suse.de, mingo@elte.hu, tglx@linutronix.de
Subject: Re: oops in oprofile/dump_trace/X86 with 2.6.24-rcX
Message-ID: <20071109114247.GC2890@zaniah>
References: <20071108014527.GA2474@localhost> <20071108105418.8b58306d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108105418.8b58306d.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2007 at 10:54 +0000, Andrew Morton wrote:

> Philippe, on Sun, 21 Oct you sent a "[patch 1/2] oProfile: oops when
> profile_pc() return ~0LU" which as far as I can tell never got applied.
> 
> Also, I have no record of [patch 2/2] from that day.  Can you please refresh
> and resend both patches asap?
> 
> I've queued the below revert of Jan's change, in case your lost [2/2] doesn't
> address Robert's oops.

I resent them, that was two separate patch not relation between them
except they touched oprofile, none of them address this oops.

-- 
regards,
Phe

