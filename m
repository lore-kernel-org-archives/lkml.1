Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZAJAbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZAJAbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 19:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753747AbZAJAbC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 19:31:02 -0500
Received: from mga12.intel.com ([143.182.124.36]:51389 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752016AbZAJAbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 19:31:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,242,1231142400"; 
   d="scan'208";a="98438880"
Message-ID: <4967EC39.2080109@linux.intel.com>
Date: Fri, 09 Jan 2009 16:30:49 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: async: make async a command line option for now
References: <200901100002.n0A02qKl010433@hera.kernel.org> <20090109161444.27139f19.rdunlap@xenotime.net>
In-Reply-To: <20090109161444.27139f19.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Sat, 10 Jan 2009 00:02:52 GMT Linux Kernel Mailing List wrote:
> 
>> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cdb80f630be5cbc23d82331f24dc4704f75b64f4
>> Commit:     cdb80f630be5cbc23d82331f24dc4704f75b64f4
>> Parent:     b32714ba29358a688ef337d5297bf4bdc9f596dc
>> Author:     Arjan van de Ven <arjan@linux.intel.com>
>> AuthorDate: Fri Jan 9 13:23:45 2009 -0800
>> Committer:  Arjan van de Ven <arjan@linux.intel.com>
>> CommitDate: Fri Jan 9 13:23:45 2009 -0800
>>
>>     async: make async a command line option for now
>>     
>>     ... and have it default off.
>>     This does allow people to work with it for testing.
> 
> 
> Is this boot option documented anywhere or did you mean to
> keep it hidden to all but inquiring minds?
> 
> 

for now low visibility is good;
in fact once the feature stabilizes it'll flip the other way around,
at which point it does need to be documented.
