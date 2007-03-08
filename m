Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbXCHTBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbXCHTBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 14:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbXCHTBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 14:01:40 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:34715 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933044AbXCHTBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 14:01:40 -0500
Date: Thu, 8 Mar 2007 10:42:02 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308184202.GP6602@sequoia.sous-sol.org>
References: <20070308170001.GA17304@sergelap.austin.ibm.com> <33939.11500.qm@web36612.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33939.11500.qm@web36612.mail.mud.yahoo.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Casey Schaufler (casey@schaufler-ca.com) wrote:
> 
> --- "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
>  
> > It's unfortunate, agreed, but
> > 
> > use of LSM as an integrity framework was also a
> > no-go.
> 
> You're going to have to justify this assertion.
> I know of at least one work-in-progress for which
> LSM works just fine. Not to mention the Integrity
> claims of SELinux.

Serge is referring to the objections to EVM/IMA
as LSM because it was not doing access control,
rather integrity measurements.  It's all in
somewhere the archives.

thanks,
-chris
