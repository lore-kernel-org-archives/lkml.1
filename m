Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZBWUfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZBWUfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbZBWUfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:35:39 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24141 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZBWUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:35:39 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: etienne <etienne.basset@numericable.fr>
Subject: Re: [PATCH][SMACK] convert smack_known list to a standard linux list.
Date: Mon, 23 Feb 2009 15:35:33 -0500
User-Agent: KMail/1.11.0 (Linux/2.6.27-gentoo-r8; KDE/4.2.0; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       LSM <linux-security-module@vger.kernel.org>, paulmck@linux.vnet.ibm.com
References: <49A1C895.5030803@numericable.fr> <49A2013A.6020508@schaufler-ca.com> <49A242C6.1000400@numericable.fr>
In-Reply-To: <49A242C6.1000400@numericable.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902231535.33392.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009 01:31:34 am etienne wrote:
> Casey Schaufler wrote:
> > etienne wrote:
> >> hello,
> >>
> >> this patch on top of [PATCH][SMACK] convert smack rule list to linux
> >> list V2 converts "smack_known" to a regular linux list. (rcu variant)
> >
> > I'm having some trouble applying this group of patches.
> > I assume that I'm starting at the wrong place. Could you
> > do a single patch to help me avoid confusion?

...

>
> here you are!
> (it is still on top of my 02/20 "[PATCH] SMACK netlabel fixes v2")

If Casey wants to ACK your Smack labeled networking patch from last week I'm 
okay with pulling it into the lblnet-2.6_next tree (it is sorta labeled 
networking related) so you can use it as a base if needed.  It would also get 
the patch into the linux-next tree which is important if you want to target 
2.6.30.

-- 
paul moore
linux @ hp

