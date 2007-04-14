Return-Path: <linux-kernel-owner+w=401wt.eu-S1751183AbXDNT2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751183AbXDNT2R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXDNT2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:28:16 -0400
Received: from electron.quantumfyre.co.uk ([87.106.55.16]:59903 "EHLO
	electron.quantumfyre.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751183AbXDNT2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:28:16 -0400
X-Greylist: delayed 1245 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 15:28:15 EDT
Date: Sat, 14 Apr 2007 20:07:28 +0100 (BST)
From: Julian Phillips <julian@quantumfyre.co.uk>
X-X-Sender: jp3@beast.quantumfyre.co.uk
To: Chris Wright <chrisw@sous-sol.org>
cc: Brian Gernhardt <benji@silverinsanity.com>,
       Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Subject: Re: GIT and the current -stable
In-Reply-To: <20070414171908.GU10574@sequoia.sous-sol.org>
Message-ID: <Pine.LNX.4.64.0704141917320.6461@beast.quantumfyre.co.uk>
References: <46206842.80203@gmail.com> <20070414083410.GU6602@sequoia.sous-sol.org>
 <5A4D6434-3DF2-4CC7-B363-260E5F945F72@silverinsanity.com>
 <20070414171908.GU10574@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2007, Chris Wright wrote:

> * Brian Gernhardt (benji@silverinsanity.com) wrote:
>> On Apr 14, 2007, at 4:34 AM, Chris Wright wrote:
>>> I've already put a tree like this up on kernel.org.  The master branch
>>> is Linus' tree, and there's branches for each of the stable releases
>>> called linux-2.6.[12-20].y (I didn't add 2.6.11.y).
>>>
>>> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6-stable.git;a=summary
>>
>> Is HEAD for that repo the most recent stable branch, or (as gitweb
>> makes it look) Linus's head.  I'd expect a "-stable" repo to point at
>> the most recent stable commit, not the most recent development
>> commit.  And I'd also expect gitweb's summary page to show the
>> shortlog for HEAd.  One of my assumptions are being broken and I
>> don't like it.  It leaves me all confused...
>
> As I mentioned.  The master branch (HEAD) is Linus' tree, and each
> stable tree is on its own branch.  You'll find shortlog summarizes the
> main branch, so yes, gitweb's summary is a bit confusing based on your
> assumptions.  This is a new tree and hasn't been publicized until now.
> It does make sense to have its head be the newest stable, I'll switch
> that around.

Would it not make more sense to point HEAD at the linux-2.6.20-y branch 
and either let master be Linus' tree or simply not have a master branch? 
Otherwise, what happens to master when the latest stable tree becomes 
linux-2.6.21-y?

-- 
Julian

  ---
Most people want either less corruption or more of a chance to
participate in it.
