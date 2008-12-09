Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbYLIKPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbYLIKPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYLIKP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:15:29 -0500
Received: from tundra.namei.org ([65.99.196.166]:1708 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYLIKP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:15:28 -0500
Date: Tue, 9 Dec 2008 21:15:02 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] user namespaces: document CFS behavior
In-Reply-To: <20081209100817.GA11886@elte.hu>
Message-ID: <alpine.LRH.1.10.0812092114140.11867@tundra.namei.org>
References: <20081208215221.GA3954@us.ibm.com> <alpine.LRH.1.10.0812090927350.8505@tundra.namei.org> <20081209024543.GA11538@elte.hu> <alpine.LRH.1.10.0812092005100.10841@tundra.namei.org> <20081209100817.GA11886@elte.hu>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Dec 2008, Ingo Molnar wrote:

> > They're already published in my tree.  Do you want me to revert them?
> 
> I've also got it published :-/ If it's at the tail of your commits, can 
> you reset it?

There have been commits since, and people are using the tree in any case.


- James
-- 
James Morris
<jmorris@namei.org>
