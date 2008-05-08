Return-Path: <linux-kernel-owner+w=401wt.eu-S1760765AbYEHCdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760765AbYEHCdY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 22:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834AbYEHCdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 22:33:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbYEHCdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 22:33:09 -0400
Date: Wed, 7 May 2008 19:32:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, steiner@sgi.com,
       holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 08 of 11] anon-vma-rwsem
In-Reply-To: <20080508022424.GU8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071930050.3024@woody.linux-foundation.org>
References: <20080507153103.237ea5b6.akpm@linux-foundation.org> <20080507224406.GI8276@duo.random> <20080507155914.d7790069.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071610490.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071637360.14337@schroedinger.engr.sgi.com>
 <alpine.LFD.1.10.0805071655100.3024@woody.linux-foundation.org> <Pine.LNX.4.64.0805071752490.14829@schroedinger.engr.sgi.com> <alpine.LFD.1.10.0805071833450.3024@woody.linux-foundation.org> <20080508015249.GT8276@duo.random>
 <alpine.LFD.1.10.0805071853500.3024@woody.linux-foundation.org> <20080508022424.GU8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrea, I'm not interested. I've stated my standpoint: the code being 
discussed is crap. We're not doing that. Not in the core VM. 

I gave solutions that I think aren't crap, but I already also stated that 
I have no problems not merging it _ever_ if no solution can be found. The 
whole issue simply isn't even worth the pain, imnsho. 

			Linus
