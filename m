Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0CLKic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:38:32 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:34456 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757270Ab0CLKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:38:31 -0500
X-IronPort-AV: E=Sophos;i="4.49,625,1262563200"; 
   d="scan'208";a="9912058"
Date: Fri, 12 Mar 2010 10:42:42 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 0 of 5] PV on HVM Xen
In-Reply-To: <201003121123.33935.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1003121024590.27222@kaball-desktop>
References: <alpine.DEB.2.00.1003101457100.28412@kaball-desktop> <201003121123.33935.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010, Sheng Yang wrote:
> On Wednesday 10 March 2010 23:46:54 Stefano Stabellini wrote:
> > Hi all,
> 
> Stefano,
> 
> And next time when you send out the patch, please be more respect to my work.
> 
> You dropped all the original author(me) of patchset, and only add a sign-off 
> for me. If you don't aware the difference, here is a snippet of 
> linux/Documentation/SummittingPatches
> 

I am truly sorry and apologise for it, I would never want to give you
the impression of being disrespectful of you and your work.
If you pay attention I manually wrote in the comments of all the past
versions of the patches that you were the original author, this time I
just forgot.
I guess it is really the time I start using git-send-email :)

Your work has been really important for my series and you deserve the
credit for it independently from which patch series gets applied.


> Another thing is, you were keeping using my old patches as your base, while I 
> was working with the reviewers to update the patch quickly. I don't think 
> that's a kind of respect to both reviewers' and my work. You would duplicate 
> reviewer's effect, especially you always repost the whole patch(and drop my 
> authorship) rather than the different part. I've split patches in order to 
> provide a code base for further development, but you complete ignored them and 
> keeping post the whole patchset based on my old patches.
> 

I don't keep using your old patches as a base but I manually rebase over
the most recent patch series you sent every time.
Obviously it is not a perfect system and sometimes I can miss something,
this is why at the beginning I asked you to work together on the same
tree: I wanted to avoid exactly this sort of issues.

My intentions are true so my proposal of working on a common tree is
still valid, just let me know when you are interested.

