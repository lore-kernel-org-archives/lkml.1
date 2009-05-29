Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbZE2OrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbZE2OrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 10:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZE2OrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 10:47:13 -0400
Received: from edu.joroinen.fi ([194.89.68.130]:35285 "EHLO edu.joroinen.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758603AbZE2OrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 10:47:12 -0400
X-Greylist: delayed 1951 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 May 2009 10:47:11 EDT
Date: Fri, 29 May 2009 17:14:39 +0300
From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
To: George Dunlap <george.dunlap@eu.citrix.com>
Cc: David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "npiggin@suse.de" <npiggin@suse.de>
Subject: Re: Xen is a feature
Message-ID: <20090529141439.GT24960@edu.joroinen.fi>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1FCE8E.2060604@eu.citrix.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 01:01:18PM +0100, George Dunlap wrote:
> David Miller wrote:
> >I don't see Ingo's comments, whether I agree with them or not, as
> >an implication of Xen being niche.  Rather I see his comments as
> >an opposition to how Xen is implemented.
> >  
> It's in his definition of "improving Linux".  Jeremy is saying that 
> allowing Linux to run as dom0 *is* improving Linux.  The lack of dom0 
> support is at this moment making life more difficult for a huge number 
> of Linux users who use Xen, including Mozilla, Debian, and Amazon.    
> Adding dom0 support would make Linux even more useful to a wide variety 
> of people not using Xen at the moment. 
> 

Like stated already earlier, there is a huge amount of Xen in use all around
the globe for server/datacenter virtualization. Personally I know many Xen 
installations in production, but not a single KVM installation (I'm sure those 
exist aswell, but personally I haven't seen those).

At the moment it's pretty painful for the distro developers to ship dom0
enabled kernels (most of the distros do ship or are waiting for upstream
dom0 enabled kernel), and also for many advanced users who build their custom Xen
based solutions.. 

The current situation is not good for anyone. We really need Xen dom0
support in mainline Linux.

Just my 2 eurocents.

-- Pasi
