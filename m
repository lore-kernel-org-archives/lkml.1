Return-Path: <linux-kernel-owner+w=401wt.eu-S1757477AbYGSBAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477AbYGSBAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbYGSBAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:00:25 -0400
Received: from mail.lang.hm ([64.81.33.126]:58127 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbYGSBAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:00:24 -0400
Date: Fri, 18 Jul 2008 18:01:14 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: David Schwartz <davids@webmaster.com>
cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: RE: [stable] Linux 2.6.25.10
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEJCOEAC.davids@webmaster.com>
Message-ID: <alpine.DEB.1.10.0807181755590.30465@asgard.lang.hm>
References: <MDEHLPKNGKAHNMBLJOLKOEJCOEAC.davids@webmaster.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, David Schwartz wrote:

> Greg KH wrote:
>
>> Personally, I omit posting full "and here is explicitly how to exploit
>> this problem" notices as that is foolish.
>
> That means only people with the time, energy, and expertise to create an
> exploit will have an exploit. This includes probably 90% of the people who
> would use the exploit maliciously

haven't you ever heard of script-kiddies? they are by far the majority of 
attacks on systems but do not have the expertise to create exploits. it 
takes someone else writing the exploit for them and packaging it to make 
them a threat.

in the meantime there's a chance for the fix to get propogated out to a 
released version and for people to upgrade their systems. providing 
exploit code along with the bugfix means that the script kiddies have the 
exploit immediatly, but the fix isn't in any released version (not even a 
-rc or daily -git snapshot)

> and 100% of the people who pose a real
> thread to the community.

this depends on how you define threat.

> It does, however, ensure that the majority of
> ordinary users won't be able to test their systems to see if they're
> vulnerable or if the vulnerability is fixed. So at least it will have some
> effect.

how many people run exploits against their production systems to 'see if 
they are fixed', very few, and those only on strict schedules with lots of 
adnvance notice and other safeguards.

David Lang

