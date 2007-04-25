Return-Path: <linux-kernel-owner+w=401wt.eu-S2992954AbXDYTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992954AbXDYTLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992958AbXDYTLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:11:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:33199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992954AbXDYTLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:11:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Dave Jones <davej@redhat.com>
Subject: Re: pgprot_writecombine() and PATs on x86
Date: Wed, 25 Apr 2007 21:10:49 +0200
User-Agent: KMail/1.9.6
Cc: Roland Dreier <rdreier@cisco.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, mst@mellanox.co.il, jackm@mellanox.co.il
References: <ada1wi8xrgt.fsf@cisco.com> <200704252019.28017.ak@suse.de> <20070425184108.GB23721@redhat.com>
In-Reply-To: <20070425184108.GB23721@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704252110.49603.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 April 2007 20:41:08 Dave Jones wrote:
> On Wed, Apr 25, 2007 at 08:19:27PM +0200, Andi Kleen wrote:
>  > On Wednesday 25 April 2007 20:02:26 Roland Dreier wrote:
>  > > Hi Eric,
>  > > 
>  > > Where do your patches to add an implementation of
>  > > pgprot_writecombine() using PATs on x86 stand?  
>  > 
>  > It's on my todo list.
> 
> Whats the status on the code at ftp://ftp.firstfloor.org/pub/ak/pat/patches ?
> I've not given it much more than a quick skim, so I'm not sure what
> it's capable of/what its missing etc..

That code has a couple of problems and is relatively broken

-Andi
