Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbXJPAfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbXJPAfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 20:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbXJPAfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 20:35:31 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:60382
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbXJPAfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 20:35:30 -0400
Date: Mon, 15 Oct 2007 17:39:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mark Gross <mgross@linux.intel.com>
cc: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Subject: Re: WANTED: kernel projects for CS students
In-Reply-To: <20071015170411.GB18550@linux.intel.com>
Message-ID: <Pine.LNX.4.64.0710151737080.3949@asgard.lang.hm>
References: <20071014190128.6e3cdb44@bree.surriel.com> <20071015170411.GB18550@linux.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Mark Gross wrote:

> On Sun, Oct 14, 2007 at 07:01:28PM -0400, Rik van Riel wrote:
>> The kernel newbies community often gets inquiries from CS students who
>> need a project for their studies and would like to do something with
>> the Linux kernel, but would also like their code to be useful to the
>> community afterwards.
>>
>> In order to make it easier for them, I am trying to put together a
>> page with projects that:
>> - Are self contained enough that the students can implement the
>>   project by themselves, since that is often a university requirement.
>> - Are self contained enough that Linux could merge the code (maybe
>>   with additional changes) after the student has been working on it
>>   for a few months.
>> - Are large enough to qualify as a student project, luckily there is
>>   flexibility here since we get inquiries for anything from 6 week
>>   projects to 6 month projects.
>>
>> If you have ideas on what projects would be useful, please add them
>> to this page (or email me):
>>
>> http://kernelnewbies.org/KernelProjects
>
> Is there already a make config option that will do a good job at setting
> a default .config file based on what is already running on a system?
>
> I get tiered of trimming down my .config for my laptop build so it takes
> less than 30min to build a kernel.
>
> Bonus credit to additional "expert" options (like those powertop puts
> out) for target uses, laptop, HPC, home file share, embedded targets....
>
> Oh, and lets make the expert configs easily extensible.

another config thing that would be nice would be to take something like 
Rob Landley's miniconfig tool and make it work well enough to be 
integrated (it creates a version of .config that only contains the things 
that need to be set, not everything that's at a default that doesn't make 
any difference)

David Lang
