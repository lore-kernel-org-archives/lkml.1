Return-Path: <linux-kernel-owner+w=401wt.eu-S1759852AbYELHqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759852AbYELHqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:46:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbYELHq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:46:28 -0400
Received: from mail43.e.nsc.no ([193.213.115.43]:51653 "EHLO mail43.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbYELHq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:46:27 -0400
Message-ID: <4827F592.50500@bakke.com>
Date: Mon, 12 May 2008 09:45:22 +0200
From: Dag Bakke <dag@bakke.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080504)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Diego 'Flameeyes' Petteno" <flameeyes@gmail.com>
Subject: Re: [PATCH] fix apple alu keyboard with numpad
References: <4814612F.5030606@bakke.com> <20080506125406.dc047710.akpm@linux-foundation.org> <Pine.LNX.4.64.0805062244130.11363@jikos.suse.cz> <48233747.1030605@bakke.com> <Pine.LNX.4.64.0805120053520.11363@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0805120053520.11363@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote, On 05/12/2008 12:54 AM:
> On Thu, 8 May 2008, Dag Bakke wrote:
> 
>>> Dag, I think Diego's patch should solve the issue you are seeing, right?
>>>
>>> [1]
>>> http://git.kernel.org/?p=linux/kernel/git/jikos/hid.git;a=commit;h=ffe6f7b799e33f51732520979f9c253a252b9d5e
>> I'll give it a shot and let you know.
> 
> Dag,
> 
> any update here, please?
> 
> Thanks,
> 

The patch works, thank you. Looks like all keys produce what I expect now.

Well. At least in X11 they do.
In the console, I get '~' instead of '=', when hitting the numpad '=' key.

This may have been no different with the patch I used previously.


Dag B
