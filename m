Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081Ab0AEHgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab0AEHgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 02:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910Ab0AEHgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 02:36:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0AEHgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 02:36:23 -0500
Date: Tue, 5 Jan 2010 08:35:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: strict copy_from_user checks issues?
Message-ID: <20100105073558.GA22037@elte.hu>
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com>
 <20100104174308.0790757c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104174308.0790757c@infradead.org>
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


* Arjan van de Ven <arjan@infradead.org> wrote:

> > Warnings cannot be switched off anymore as it was the case in your first 
> > version. However gcc seems to report quite a few false positives so it 
> > would be good if it could be turned off again.
> 
> hmm I thought most got fixed.. I'd be surprised if this part is architecture 
> specific..... I rather fix the few cases left than disable the warning to be 
> honest. It's not many, at least not on x86.

Would be nice to see the warnings reported.

Thanks,

	Ingo
