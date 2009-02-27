Return-Path: <linux-kernel-owner+w=401wt.eu-S1758638AbZB0Bjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638AbZB0Bjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 20:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZB0Bjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 20:39:36 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47173 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbZB0Bjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 20:39:35 -0500
Date: Thu, 26 Feb 2009 19:39:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] keys: work correctly with user namespaces
Message-ID: <20090227013933.GA6688@us.ibm.com>
References: <20090227002709.GA31049@us.ibm.com> <alpine.LRH.2.00.0902271236260.18643@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902271236260.18643@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Thu, 26 Feb 2009, Serge E. Hallyn wrote:
> 
> > Hi James,
> > 
> > the following 4 patches apply on top of current security-testing-2.6 next
> > branch.  They implement strict separation of keys in different user
> > namespaces.  Do you mind sticking these in the security-testing tree?
> > 
> > With these patches I can run the keyutils-tests simultaneously in two
> > namespaces with no problems or failures.
> > 
> 
> Applied.
> 
> -- 
> James Morris
> <jmorris@namei.org>

Thanks, James.

-serge
