Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZKOMJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZKOMJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 07:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbZKOMJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 07:09:18 -0500
Received: from lo.gmane.org ([80.91.229.12]:60858 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbZKOMJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 07:09:18 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: Does a kernel assisted file system reorder make sense?
Date: Sun, 15 Nov 2009 11:38:47 +0000
Message-ID: <7r55t6-9up.ln1@chipmunk.wormnet.eu>
References: <4AFFDA7C.6010907@cv-sv.de>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Volkmann <haveaniceday@cv-sv.de> wrote:
> 
> I just have read some articles about faster booting systems
> (Ubuntu 9.10) , SSD, hard disks, latency and seek times...
> 
> Due to this I have some ideas which I like to discuss.
> I am for sure not the first with this idea, but I do not
> find any discussion about it. :)
> 
> [snipped]
> 
> But this would only make sense if a system boot is delayed by
> hard disk seek times. I have no SSD to check if a SSD boots
> faster. Does anyone have the experience if a SSD boots faster?
> 
...be faster still just to suspend/resume to RAM or disk surely?

I like to reduce my boot time by...erm...not booting :)

Cheers

-- 
Alexander Clouter
.sigmonster says: It is the wise bird who builds his nest in a tree.

