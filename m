Return-Path: <linux-kernel-owner+w=401wt.eu-S1760536AbXGDLH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760536AbXGDLH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXGDLHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:07:20 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:57143 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171AbXGDLHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:07:18 -0400
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jul 2007 07:07:18 EDT
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 4 Jul 2007 16:58:39 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH -mm 0/3] configfs: Miscellaneous cleanups
In-Reply-To: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0707041656060.28838@cselinux1.cse.iitk.ac.in>
References: <20070704110701.28503.95359.sendpatchset@cselinux1.cse.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Argh, my sendpatchset script got David's address wrong. I've made up
for that by sending the patchset separately to him -- didn't want to
spam the entire list.

On Wed, 4 Jul 2007, Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [0/3] configfs: Miscellaneous cleanups
> 
> Simple cleanups for configfs (plus DLM and OCFS2, wherever applicable).
> This is diffed against 2.6.22-rc6-mm1.
> 
> [1/3] configfs+dlm: Separate out __CONFIGFS_ATTR into configfs.h
> [2/3] configfs+dlm+ocfs2: Convert subsystem semaphore to mutex
> [3/3] configfs+dlm: Rename config_group_find_obj and state semantics clearly
> 
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> Satyam
> 
