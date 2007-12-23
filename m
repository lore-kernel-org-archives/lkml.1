Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbXLWMNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbXLWMNc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:13:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbXLWMNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:13:22 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:37047 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLWMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:13:21 -0500
Message-ID: <476E50DC.1040701@garzik.org>
Date: Sun, 23 Dec 2007 07:13:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org> <alpine.LFD.0.9999.0712230701520.14863@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0712230701520.14863@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Sun, 23 Dec 2007, Jeff Garzik wrote:
> 
>> Another year, another update!  :)
>>
>> The kernel hacker's guide to git has received some updates:
>>
>> 	http://linux.yyz.us/git-howto.html
>>
>> This includes all the input sent to me in the past several months,
>> as well as a few new tips and tricks I use on a regular basis.
>>
>> In general, this document is designed to be a quick-start cookbook,
>> and not a comprehensive introduction.
> 
> there's one issue i have with this document, and that's that i wish it
> more carefully distinguished between regular git "user" tasks, and git
> "developer" tasks.
> 
> i may be mistaken, but it would seem that a lot of folks are going to
> be what i call basic users, who only want to update their git tree,
> check the logs, check the status and so on.  and if they start to get
> ambitious, they might make some changes to the tree, do a diff, and
> submit a patch.  but in the beginning, they won't be making commits or
> switching branches, etc.
> 
> in short, i can see the value of something like a "getting started
> with git as a basic user" tutorial.  does such a thing exist?


hmmm.  There's the tutorial linked at the bottom of the page, which in 
turn links to http://www.kernel.org/pub/software/scm/git/docs/everyday.html

git is a developer's tool, so I sorta targetted that audience.  I 
definitely agree that is not only git audience...

	Jeff


