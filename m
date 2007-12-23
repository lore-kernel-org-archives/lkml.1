Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbXLWMIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbXLWMIw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbXLWMIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:08:41 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:59318 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbXLWMIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:08:40 -0500
Date: Sun, 23 Dec 2007 07:08:37 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
In-Reply-To: <476E42BF.1010300@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712230701520.14863@localhost.localdomain>
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Dec 2007, Jeff Garzik wrote:

> Another year, another update!  :)
>
> The kernel hacker's guide to git has received some updates:
>
> 	http://linux.yyz.us/git-howto.html
>
> This includes all the input sent to me in the past several months,
> as well as a few new tips and tricks I use on a regular basis.
>
> In general, this document is designed to be a quick-start cookbook,
> and not a comprehensive introduction.

there's one issue i have with this document, and that's that i wish it
more carefully distinguished between regular git "user" tasks, and git
"developer" tasks.

i may be mistaken, but it would seem that a lot of folks are going to
be what i call basic users, who only want to update their git tree,
check the logs, check the status and so on.  and if they start to get
ambitious, they might make some changes to the tree, do a diff, and
submit a patch.  but in the beginning, they won't be making commits or
switching branches, etc.

in short, i can see the value of something like a "getting started
with git as a basic user" tutorial.  does such a thing exist?

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
