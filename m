Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbZAFX5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbZAFX5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 18:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZAFX5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 18:57:43 -0500
Received: from mail.fieldses.org ([141.211.133.115]:45083 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZAFX5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 18:57:42 -0500
Date: Tue, 6 Jan 2009 18:57:34 -0500
To: James Morris <jmorris@namei.org>
Cc: David Howells <dhowells@redhat.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] CRED: Fix regression in cap_capable() as shown up by
	sys_faccessat() [ver #3]
Message-ID: <20090106235734.GG13785@fieldses.org>
References: <alpine.LRH.1.10.0901051301590.14359@tundra.namei.org> <24959.1230694093@redhat.com> <20081230134248.GA30124@lst.de> <21275.1230736542@redhat.com> <5145.1231280821@redhat.com> <alpine.LRH.1.10.0901070953300.29967@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0901070953300.29967@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 09:53:48AM +1100, James Morris wrote:
> On Tue, 6 Jan 2009, David Howells wrote:
> 
> > 
> > Fix a regression in cap_capable() due to:
> > 
> > 	commit 3b11a1decef07c19443d24ae926982bc8ec9f4c0
> > 	Author: David Howells <dhowells@redhat.com>
> > 	Date:   Fri Nov 14 10:39:26 2008 +1100
> > 
> > 	    CRED: Differentiate objective and effective subjective credentials on a task
> > 
> 
> Applied to:
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Thanks!  When should that be in mainline?

--b.
