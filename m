Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbZBFIP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbZBFIP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZBFIPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:15:15 -0500
Received: from tundra.namei.org ([65.99.196.166]:3406 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbZBFIPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:15:13 -0500
Date: Fri, 6 Feb 2009 19:14:54 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/6] integrity
In-Reply-To: <1233887341.3135.14.camel@localhost.localdomain>
Message-ID: <alpine.LRH.1.10.0902061914420.16725@tundra.namei.org>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>  <alpine.LRH.1.10.0902061059510.13961@tundra.namei.org> <1233887341.3135.14.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Feb 2009, Mimi Zohar wrote:

> On Fri, 2009-02-06 at 11:00 +1100, James Morris wrote:
> > I seem to be getting a bunch of these in my logs with IMA running:
> > 
> > auditd[1746]: dispatch err (Bad address) event lost
> > 
> 
> auditd needs to reflect the integrity definitions defined in
> include/linux/audit.h.  ausearch-parse needs to be updated as well. For
> which version of auditd should I post a patch? I have one for
> audit-1.7.9.

I don't know, ask the audit folk.

-- 
James Morris
<jmorris@namei.org>
