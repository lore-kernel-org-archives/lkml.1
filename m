Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbYICPox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbYICPox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 11:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYICPoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 11:44:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbYICPop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 11:44:45 -0400
Date: Wed, 3 Sep 2008 08:43:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [GIT] Fix SELinux memory leak regression for 2.6.27
In-Reply-To: <alpine.LRH.1.10.0809032238080.21379@tundra.namei.org>
Message-ID: <alpine.LFD.1.10.0809030843310.3259@nehalem.linux-foundation.org>
References: <alpine.LRH.1.10.0809031015260.17746@tundra.namei.org> <alpine.LRH.1.10.0809032238080.21379@tundra.namei.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, James Morris wrote:
> On Wed, 3 Sep 2008, James Morris wrote:
> 
> > This is causing recent Fedora systems to die a slow and painful death.  
> > Please pull.
> 
> Further review has raised an issue with this patch, an updated version 
> should be available soon.

Ahh, that also explains why the branch isn't there any more. Thanks,

		Linus
