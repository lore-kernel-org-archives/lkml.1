Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbZLEHS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbZLEHS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 02:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752494AbZLEHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 02:18:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbZLEHS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 02:18:28 -0500
Date: Sat, 5 Dec 2009 08:18:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Shaun Patterson <shaunpatterson@gmail.com>, pq@iki.fi,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Spelling in in /arch/x86/mm
Message-ID: <20091205071822.GC25383@elte.hu>
References: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com>
 <20091204070008.GA9761@elte.hu>
 <alpine.LNX.2.00.0912041340380.3755@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.0912041340380.3755@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Fri, 4 Dec 2009, Ingo Molnar wrote:
> 
> > > Spelling fix
> > > Signed-off-by: Shaun Patterson shaunpatterson@gmail.com
> > > ---
> > > ?arch/x86/mm/kmmio.c |??? 2 +-
> > > ?1 files changed, 1 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> > > index 16ccbd7..72f1572 100644
> > > --- a/arch/x86/mm/kmmio.c
> > > +++ b/arch/x86/mm/kmmio.c
> > > @@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
> > > ? * 2. remove_kmmio_fault_pages()
> > > ? *??? Remove the pages from kmmio_page_table.
> > > ? * 3. rcu_free_kmmio_fault_pages()
> > > - *??? Actally free the kmmio_fault_page structs as with RCU.
> > > + *??? Actually free the kmmio_fault_page structs as with RCU.
> > > ? */
> > > ?void unregister_kmmio_probe(struct kmmio_probe *p)
> > > ?{
> > 
> > The fix looks good - but the patch is mangled. Please see 
> > Documentation/email-clients.txt for details.
> 
> Plus the Signed-off-by: line doesn't really have correct format (the valid 
> e-mail address format is expected here).

I can fix that - not the garbled-beyond-recognition patch though.

	Ingo
