Return-Path: <linux-kernel-owner+w=401wt.eu-S1751987AbXA2UA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbXA2UA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 15:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbXA2UA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 15:00:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXA2UAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 15:00:25 -0500
Message-ID: <45BE50B8.2080001@redhat.com>
Date: Mon, 29 Jan 2007 14:53:28 -0500
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060803)
MIME-Version: 1.0
To: Pete Zaitcev <zaitcev@redhat.com>
CC: linux-kernel@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Juju
References: <20070124223745.33278eb4.zaitcev@redhat.com>	<45B91EAB.9080004@redhat.com> <20070128161345.9dd3c086.zaitcev@redhat.com>
In-Reply-To: <20070128161345.9dd3c086.zaitcev@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete Zaitcev wrote:
> On Thu, 25 Jan 2007 16:18:35 -0500, Kristian Høgsberg <krh@redhat.com> wrote:
> 
>> Indeed, I've just moved to an in-tree development model now.  I still think 
>> the out-off-tree model is a good way to prototype, get started and reach 
>> "critical mass" with your driver.  But as I'm starting to integrate and sync 
>> with Stefans tree now, an in-tree model is a lot easier to work with.  The 
>> tree is here
>>
>>    git://people.freedesktop.org/~krh/linux-2.6
> 
> This seems to have disappeared. Was it moved or dropped?

No, it's still there, and I just did a git clone on it.  How does it fail for 
you?  In any case, you're probably better of pulling from Stefans kernel.org tree:

   git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git

since that's where new work is going to show up.  I'm still trying to figure 
out a good workflow for this, but if all patches are going to through 
linux1394-devel, there's not much point in me publishing a branch in the 
freedesktop.org repo, if the patches are going to be edited/tweaked and the 
committed to Stefans repo.

Kristian

