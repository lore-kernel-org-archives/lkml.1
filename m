Return-Path: <linux-kernel-owner+w=401wt.eu-S1755476AbYJHPiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476AbYJHPiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 11:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754582AbYJHPhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 11:37:55 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56445 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbYJHPhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:37:54 -0400
Subject: Re: [PATCH 2/4] integrity: special fs magic
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081008130056.GC31684@infradead.org>
References: <cover.1223401603.git.zohar@linux.vnet.ibm.com>
	 <87b9b5f88d5ed93a7985c14b413cf8d74ceea69c.1223401604.git.zohar@linux.vnet.ibm.com>
	 <20081008130056.GC31684@infradead.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 11:07:49 -0400
Message-Id: <1223478469.3063.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 09:00 -0400, Christoph Hellwig wrote:
> On Tue, Oct 07, 2008 at 02:00:12PM -0400, Mimi Zohar wrote:
> > Discussion on the mailing list questioned the use of these
> > magic values in userspace, concluding these values are already
> > exported to userspace via statfs and their correct/incorrect
> > usage is left up to the userspace application.
> > 
> >   - Move special fs magic number definitions to magic.h
> >   - Add magic.h include
> 
> This should be patch 1, and we can put in in ASAP even if the rest needs
> some more work.
> 

The ordering of the first and second patches is interchangeable without
requiring any patch changes.  

Mimi

