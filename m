Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZFZKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZFZKrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZFZKrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 06:47:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37339 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbZFZKrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 06:47:09 -0400
Date: Fri, 26 Jun 2009 12:47:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 2/9] x86: introduce a set of platform feature flags
Message-ID: <20090626104703.GA12446@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E1@orsmsx508.amr.corp.intel.com> <20090626072218.GH14078@elte.hu> <20090626101446.114edbe2@lxorguk.ukuu.org.uk> <20090626094514.GB12571@elte.hu> <20090626111731.539f963e@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626111731.539f963e@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0015]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Which bit is not clear? We've been continuously 'driverizing' 
> > the
> 
> What do you mean by "driverizing". You keep using your made up 
> word but since nobody else knows what you mean its not productive 
> to have the discussion using invented terms like that.

Yeah, it's a made up shortcut for "turning previously monolithic 
code into structured, driver-alike code with a driver data 
structure, possible data fields and function callbacks". See the x86 
examples i cited.

	Ingo
