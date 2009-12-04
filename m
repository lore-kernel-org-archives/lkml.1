Return-Path: <linux-kernel-owner+w=401wt.eu-S932106AbZLDMli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106AbZLDMli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:41:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZLDMli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:41:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:44364 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585AbZLDMlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:41:37 -0500
Date: Fri, 4 Dec 2009 13:41:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>, Shaun Patterson <shaunpatterson@gmail.com>
Cc: pq@iki.fi, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Spelling in in /arch/x86/mm
In-Reply-To: <20091204070008.GA9761@elte.hu>
Message-ID: <alpine.LNX.2.00.0912041340380.3755@pobox.suse.cz>
References: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com> <20091204070008.GA9761@elte.hu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Ingo Molnar wrote:

> > Spelling fix
> > Signed-off-by: Shaun Patterson shaunpatterson@gmail.com
> > ---
> > ?arch/x86/mm/kmmio.c |??? 2 +-
> > ?1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> > index 16ccbd7..72f1572 100644
> > --- a/arch/x86/mm/kmmio.c
> > +++ b/arch/x86/mm/kmmio.c
> > @@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
> > ? * 2. remove_kmmio_fault_pages()
> > ? *??? Remove the pages from kmmio_page_table.
> > ? * 3. rcu_free_kmmio_fault_pages()
> > - *??? Actally free the kmmio_fault_page structs as with RCU.
> > + *??? Actually free the kmmio_fault_page structs as with RCU.
> > ? */
> > ?void unregister_kmmio_probe(struct kmmio_probe *p)
> > ?{
> 
> The fix looks good - but the patch is mangled. Please see 
> Documentation/email-clients.txt for details.

Plus the Signed-off-by: line doesn't really have correct format (the valid 
e-mail address format is expected here).

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
