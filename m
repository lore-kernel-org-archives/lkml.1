Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYGaTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYGaTtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754975AbYGaTtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:49:41 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:38070 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754763AbYGaTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:49:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=AOWLyIUO77cRjMgMriraittqPoTjnjQ9rz4OoBr/vogESZJaPD8EyYHCqZ7mwwe1dKykzKtsCxbz6kC1ku7ndD5i0e2l5QsajYWPpwFEPJ/6/bS3axvRAaRu4HurOBlb;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: dma-coherent: add documentation to new interfaces
Date: Thu, 31 Jul 2008 12:49:35 -0700
User-Agent: KMail/1.9.9
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu
References: <200807290301.m6T317GG021226@hera.kernel.org> <20080730104650.GA16416@doriath.ww600.siemens.net> <20080730072811.902b55e0.randy.dunlap@oracle.com>
In-Reply-To: <20080730072811.902b55e0.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311249.36071.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 30, 2008 7:28 am Randy Dunlap wrote:
> On Wed, 30 Jul 2008 14:46:50 +0400 Dmitry Baryshkov wrote:
> > On Tue, Jul 29, 2008 at 01:17:57PM -0700, Randy Dunlap wrote:
> > > On Tue, 29 Jul 2008 03:01:07 GMT Linux Kernel Mailing List wrote:
> > > > Gitweb:    
> > > > http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;
> > > >a=commit;h=b6d4f7e3ef25beb8c658c97867d98883e69dc544 Commit:    
> > > > b6d4f7e3ef25beb8c658c97867d98883e69dc544
> > > > Parent:     8fa8b9fbab90c74139e8e868fe5b30b6a9f6be65
> > > > Author:     Dmitry Baryshkov <dbaryshkov@gmail.com>
> > > > AuthorDate: Sun Jul 20 15:01:10 2008 +0400
> > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > CommitDate: Sun Jul 20 21:22:00 2008 +0200
> > > >
> > > >     dma-coherent: add documentation to new interfaces
> > >
> > > Hi,
> > > Please fix these to be proper kernel-doc notation, as described in
> > > Documentation/kernel-doc-nano-HOWTO.txt ...
> >
> > Please consider this patch:
>
> Looks good.  Thanks.
>
> Jesse or Ingo:  will one of you merge this, please?

Just pushed it into my for-linus branch.  I added your "Acked-by" too, thanks 
for checking it out.

Jesse
