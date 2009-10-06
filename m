Return-Path: <linux-kernel-owner+w=401wt.eu-S933082AbZJFSWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082AbZJFSWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933056AbZJFSWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:22:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933026AbZJFSWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:22:38 -0400
Date: Tue, 6 Oct 2009 11:20:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Theodore Tso <tytso@mit.edu>
cc: Ingo Molnar <mingo@elte.hu>, Dirk Hohndel <hohndel@infradead.org>,
       Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
In-Reply-To: <20091006174450.GC24677@mit.edu>
Message-ID: <alpine.LFD.2.01.0910061116180.3432@localhost.localdomain>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
 <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <alpine.LFD.2.01.0910060828530.3432@localhost.localdomain> <20091006174450.GC24677@mit.edu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Oct 2009, Theodore Tso wrote:
> 
> It's actually not quite so bad.  If you take into account
> Extraversion, the stats that you get look like this[1]:

I'm a moron. Thanks. I wanted to do just a simple grep, and in the process 
I entirely missed that obvious thing.

> That actually shows that well over half of the commit based off of
> 2.6.31 were actually based off of some 2.6.31-rc release, based on
> something *before* 2.6.31 released.

Yup. Goodie. And I feel much better about our development environment now, 
since that is how it's supposed to work.

		Linus
