Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbYFYIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbYFYIrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 04:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYFYIrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 04:47:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45547 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYFYIrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 04:47:21 -0400
Date: Wed, 25 Jun 2008 10:47:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>
Subject: Re: [PATCH 36 of 36] x86_64/paravirt: Make load_gs_index() a
	paravirt operation
Message-ID: <20080625084700.GB11524@elte.hu>
References: <patchbomb.1214367536@localhost> <30130237d2ea98577dd4.1214367572@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30130237d2ea98577dd4.1214367572@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

patch logistics detail: the signoff order suggests it's been authored by 
Eduardo - but there's no From line to that effect - should i change it 
accordingly?

	Ingo
