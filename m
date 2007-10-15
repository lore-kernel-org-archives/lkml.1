Return-Path: <linux-kernel-owner+w=401wt.eu-S932928AbXJOTzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbXJOTzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 15:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932261AbXJOTyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:54:54 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:54898 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbXJOTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:54:53 -0400
Message-ID: <4713C582.4000504@debian.org>
Date: Mon, 15 Oct 2007 21:54:42 +0200
From: Giacomo Catenazzi <cate@debian.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Mark Gross <mgross@linux.intel.com>, Rik van Riel <riel@surriel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com> <20071015183017.GB23130@uranus.ravnborg.org>
In-Reply-To: <20071015183017.GB23130@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Oct 15, 2007 at 10:04:11AM -0700, Mark Gross wrote:
>> On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
>>> The kernel newbies community often gets inquiries from CS students who
>>> need a project for their studies and would like to do something with
>>> the Linux kernel, but would also like their code to be useful to the
>>> community afterwards.
>>>
>>> In order to make it easier for them, I am trying to put together a
>>> page with projects that:
>>> - Are self contained enough that the students can implement the
>>>   project by themselves, since that is often a university requirement.
>>> - Are self contained enough that Linux could merge the code (maybe
>>>   with additional changes) after the student has been working on it
>>>   for a few months.
>>> - Are large enough to qualify as a student project, luckily there is
>>>   flexibility here since we get inquiries for anything from 6 week
>>>   projects to 6 month projects.
>>>
>>> If you have ideas on what projects would be useful, please add them
>>> to this page (or email me):
>>>
>>> http://kernelnewbies.org/KernelProjects
>> Is there already a make config option that will do a good job at setting
>> a default .config file based on what is already running on a system?  
> I have discussed this briefly with Kay Sievers.
> What udev can provide is the list of modules needed, so what the kernel
> need to provide is a simple module to CONFIG option(s) converter + a base
> config to start out with.
> Nothing particular difficult but needs a few days work to do.

could you explain better what you need?  I think I've already such
tools ;-)

ciao
	cate
