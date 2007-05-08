Return-Path: <linux-kernel-owner+w=401wt.eu-S967545AbXEHAax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967545AbXEHAax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 20:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967538AbXEHAav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 20:30:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967492AbXEHAau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 20:30:50 -0400
Message-ID: <463FC42B.7040503@redhat.com>
Date: Mon, 07 May 2007 20:28:27 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Olaf Hering <olh@suse.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       akpm@linux-foundation.org, linux1394-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org
Subject: Re: [git pull] New firewire stack
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au> <46399BDE.4040605@s5r6.in-berlin.de> <20070503114854.GA12731@suse.de> <20070505211713.GA4016@suse.de>
In-Reply-To: <20070505211713.GA4016@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Hering wrote:
> On Thu, May 03, Olaf Hering wrote:
> 
>> On Thu, May 03, Stefan Richter wrote:
>>
>>> 	ieee1394-old
>> Noone will seriously ship two firewire stacks, so that cant be the
>> issue (for distributors). 
>>
>> Once there is a way to easily switch between kernel releases, I'm ok
>> with whatever module names you pick. 
> 
> This patch loads fw-sbp2 if sbp2 is still in the config file. So one can
> go back and forth between releases without worry about the root
> filesystem drivers.

That's a good solution, that should work.  I've committed it locally, will 
push out changes soon.

thanks,
Kristian

