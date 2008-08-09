Return-Path: <linux-kernel-owner+w=401wt.eu-S1760916AbYHIBWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760916AbYHIBWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 21:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYHIBWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 21:22:09 -0400
Received: from mail.lang.hm ([64.81.33.126]:33518 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYHIBWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 21:22:08 -0400
Date: Fri, 8 Aug 2008 18:21:54 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?J=F6rg_Ostertag?= <Joerg.Ostertag@avira.com>
cc: Theodore Tso <tytso@mit.edu>, Rik van Riel <riel@redhat.com>,
       Eric Paris <eparis@redhat.com>, Greg KH <greg@kroah.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "Press, Jonathan" <Jonathan.Press@ca.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] Threat model for Unix Computers
In-Reply-To: <200808081248.55590.Joerg.Ostertag@avira.com>
Message-ID: <alpine.DEB.1.10.0808081818430.4561@asgard.lang.hm>
References: <20080805211445.GA28304@kroah.com> <20080805204600.03ceca31@bree.surriel.com> <20080806014435.GF8224@mit.edu> <200808081248.55590.Joerg.Ostertag@avira.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, J?rg Ostertag wrote:

> Another threads would be:
> 	- giving access to the Desktop-PC to guest-users for
> 		 "just let me look up something in the internet"
> 	  and the guest-user on the Desktop not informing about the (in his point of
> 	  view) urgent installation of there beloved
> 	  Browser-malware^H^H^H^H^H -adware ^H^H^H^H^H -extention

if you give the guest user access to your account this is the same as the 
clueless desktop user.

if you make a new account for that user the standard *nix permissions and 
user seperation come to your rescue, they may infect that temporary 
account, but that won't infect the normal user.

David Lang
