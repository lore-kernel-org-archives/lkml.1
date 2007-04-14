Return-Path: <linux-kernel-owner+w=401wt.eu-S1753669AbXDNPmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbXDNPmS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXDNPmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:42:18 -0400
Received: from vs072.rosehosting.com ([216.114.78.72]:40753 "EHLO
	silverinsanity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbXDNPmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:42:18 -0400
X-Greylist: delayed 1627 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 11:42:18 EDT
In-Reply-To: <20070414083410.GU6602@sequoia.sous-sol.org>
References: <46206842.80203@gmail.com> <20070414083410.GU6602@sequoia.sous-sol.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5A4D6434-3DF2-4CC7-B363-260E5F945F72@silverinsanity.com>
Cc: Rene Herman <rene.herman@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       git@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Brian Gernhardt <benji@silverinsanity.com>
Subject: Re: GIT and the current -stable
Date: Sat, 14 Apr 2007 11:15:00 -0400
To: Chris Wright <chrisw@sous-sol.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 14, 2007, at 4:34 AM, Chris Wright wrote:

> I've already put a tree like this up on kernel.org.  The master branch
> is Linus' tree, and there's branches for each of the stable releases
> called linux-2.6.[12-20].y (I didn't add 2.6.11.y).
>
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6- 
> stable.git;a=summary

Is HEAD for that repo the most recent stable branch, or (as gitweb  
makes it look) Linus's head.  I'd expect a "-stable" repo to point at  
the most recent stable commit, not the most recent development  
commit.  And I'd also expect gitweb's summary page to show the  
shortlog for HEAd.  One of my assumptions are being broken and I  
don't like it.  It leaves me all confused...

(I'd just clone your repo and look for myself, but I'm still pulling  
Linus's tree for the first time and I don't have a fast connection.)

~~ Brian
