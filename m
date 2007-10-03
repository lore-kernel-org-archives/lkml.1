Return-Path: <linux-kernel-owner+w=401wt.eu-S1757376AbXJCLiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757376AbXJCLiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:38:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXJCLhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:37:54 -0400
Received: from mx10.go2.pl ([193.17.41.74]:45716 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754675AbXJCLhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:37:54 -0400
Date: Wed, 3 Oct 2007 13:40:27 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Schwartz <davids@webmaster.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071003114027.GA3828@ff.dom.local>
References: <20071002060607.GA18588@elte.hu> <20071003080224.GB1726@ff.dom.local> <20071003081613.GA29904@elte.hu> <20071003085636.GC1726@ff.dom.local> <20071003091058.GB7802@elte.hu> <20071003095057.GD1726@ff.dom.local> <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b647ffbd0710030355p116f9b36vae3f24e652921de6@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2007 at 12:55:34PM +0200, Dmitry Adamushko wrote:
...
> just a quick patch, not tested and I've not evaluated all possible
> implications yet.
> But someone might give it a try with his/(her -- are even more
> welcomed :-) favourite sched_yield() load.

Of course, after some evaluation by yourself and Ingo the most
interesting should be Martin's Michlmayr testing, so I hope you'll
Cc him too?!

Jarek P.
