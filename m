Return-Path: <linux-kernel-owner+w=401wt.eu-S1753515AbYGHEtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbYGHEtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 00:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbYGHEtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 00:49:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:38677 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYGHEtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 00:49:13 -0400
Date: Mon, 7 Jul 2008 21:49:05 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: david@lang.hm
Cc: "Altobelli, David" <david.altobelli@hp.com>, Pavel Machek <pavel@suse.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>
Subject: Re: [PATCH][resubmit] HP iLO driver
Message-ID: <20080707214905.157be089@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm>
References: <20080623160052.GA7616@ldl.fc.hp.com>
	<20080627191458.GA10872@ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CE586@G1W1215.americas.hpqcorp.net>
	<20080707160658.GB1794@elf.ucw.cz>
	<CF70AA892F109448AEA269483B3A983903BB8CEA25@G1W1215.americas.hpqcorp.net>
	<alpine.DEB.1.10.0807072127390.12950@asgard.lang.hm>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jul 2008 21:41:41 -0700 (PDT)
david@lang.hm wrote:
> umm, by merging the code a you reveal a lot of what they are
> attempting to keep secret. what's to stop someone from reading the
> code and writing the documentation?
> 
> that really should be someone at HP if you don't want to publish the 
> exising documentation (since you are submitting the code)
> 

Hi,

I think you're being quite unreasonable here.
In Linux we accept well written drivers even if there is no hardware
docs. Sure we prefer them to be available, but is has never been a
requirement, nor should it. I know that some other open source OSes do
demand this, but Linux is not one of them. We explicitly accept drivers
written with NDA docs, or drivers written by vendors. 
It's the code that talks.
(and well written code is often worth more than the shoddy docs that we
sometimes get)

Greetings,
   Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
