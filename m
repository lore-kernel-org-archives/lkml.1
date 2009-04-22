Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZDVFaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZDVFaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 01:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZDVF3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 01:29:43 -0400
Received: from adelie.canonical.com ([91.189.90.139]:42412 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbZDVF3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 01:29:42 -0400
Message-ID: <49EEAB43.5010908@canonical.com>
Date: Wed, 22 Apr 2009 07:29:39 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, jkosina@suse.cz,
       ubuntuLp-ugeuder@sneakemail.com
Subject: Re: [PATCH] vgacon: Return the upper half of 512 character fonts
References: <49EDDB8E.5020200@canonical.com> <20090421135454.6ac430fb.akpm@linux-foundation.org>
In-Reply-To: <20090421135454.6ac430fb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 21 Apr 2009 16:43:26 +0200
> Stefan Bader <stefan.bader@canonical.com> wrote:
> 
>> From: Stefan Bader <stefan.bader@canonical.com>
>> Date: Fri, 17 Apr 2009 23:21:05 +0200
>> Subject: [PATCH] vgacon: Return the upper half of 512 character fonts
>>
>> Bug: #355057
> 
> I think it's OK (and often good) to include the bug references in the
> changelog.  But nobody will have any clue which bug tracking system
> this refers to!
> 
> A full URL would be appropriate.
> 
> <googles for a while>
> 
> The form I use is
> 
> 	Addresses https://bugs.launchpad.net/ubuntu/+source/linux/+bug/355057
> 
True, the current form is used here to generate changelog and either should not 
go outside or, even better, I should make it a default to add another tag with 
the complete link which then helps all.

Stefan

-- 

When all other means of communication fail, try words!


