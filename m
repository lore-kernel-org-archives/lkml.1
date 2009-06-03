Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZFCWxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZFCWxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 18:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZFCWxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 18:53:13 -0400
Received: from tundra.namei.org ([65.99.196.166]:52346 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578AbZFCWxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 18:53:12 -0400
Date: Thu, 4 Jun 2009 08:52:21 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Larry H." <research@subreption.com>
cc: Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <20090603172123.GG6701@oblivion.subreption.com>
Message-ID: <alpine.LRH.2.00.0906040837430.30842@tundra.namei.org>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com>
 <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <1244041914.12272.64.camel@localhost.localdomain> <alpine.DEB.1.10.0906031134410.13551@gentwo.org> <20090603162831.GF6701@oblivion.subreption.com> <4A26A689.1090300@redhat.com>
 <20090603172123.GG6701@oblivion.subreption.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Larry H. wrote:

> whenever it is feasible, IMHO. I think everyone here will agree that
> SELinux has a track of being disabled by users after installation
> because they don't want to invest the necessary time on understanding
> and learning the policy language or management tools.

The Fedora smolt stats show an overwhelming majority of people leave it 
running.  Many don't know it's there at all and never have problems.  
It's known to have saved many everyday systems from breaches.

That's not to say that a significant number of people don't disable it, 
similarly to the way people disable iptables, use weak passwords, drive 
without seat belts, and cycle without helmets.  We do need to try and keep 
the default as safe as possible.


- James
-- 
James Morris
<jmorris@namei.org>
