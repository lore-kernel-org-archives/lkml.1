Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZLDHkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZLDHkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:40:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbZLDHkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:40:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752379AbZLDHkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:40:07 -0500
Date: Fri, 4 Dec 2009 08:00:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shaun Patterson <shaunpatterson@gmail.com>
Cc: pq@iki.fi, linux-kernel@vger.kernel.org, trivial@kernel.org,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] Spelling in in /arch/x86/mm
Message-ID: <20091204070008.GA9761@elte.hu>
References: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8cdcc00912031711y3f5f182cy79a1067afb6a8d6a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaun Patterson <shaunpatterson@gmail.com> wrote:

> Spelling fix
> Signed-off-by: Shaun Patterson shaunpatterson@gmail.com
> ---
> ?arch/x86/mm/kmmio.c |??? 2 +-
> ?1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> index 16ccbd7..72f1572 100644
> --- a/arch/x86/mm/kmmio.c
> +++ b/arch/x86/mm/kmmio.c
> @@ -490,7 +490,7 @@ static void remove_kmmio_fault_pages(struct rcu_head *head)
> ? * 2. remove_kmmio_fault_pages()
> ? *??? Remove the pages from kmmio_page_table.
> ? * 3. rcu_free_kmmio_fault_pages()
> - *??? Actally free the kmmio_fault_page structs as with RCU.
> + *??? Actually free the kmmio_fault_page structs as with RCU.
> ? */
> ?void unregister_kmmio_probe(struct kmmio_probe *p)
> ?{

The fix looks good - but the patch is mangled. Please see 
Documentation/email-clients.txt for details.

Thanks,

	Ingo

