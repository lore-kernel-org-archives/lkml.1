Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYC3UWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYC3UWR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 16:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYC3UWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 16:22:12 -0400
Received: from mail-07.jhb.wbs.co.za ([196.2.97.4]:30244 "EHLO
	mail-07.jhb.wbs.co.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYC3UWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 16:22:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoICAMCT70fEAmHGgWdsb2JhbACRQgEBECaVMw
From: Bongani Hlope <bonganilinux@mweb.co.za>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
Date: Sun, 30 Mar 2008 22:22:20 +0200
User-Agent: KMail/1.9.9
Cc: Douglas Schilling Landgraf <dougsland@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <20080330162006.GA6048@joi>
In-Reply-To: <20080330162006.GA6048@joi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803302222.20457.bonganilinux@mweb.co.za>
X-Original-Subject: Re: 2.6.25-rc regression: bttv: oops on radio access (bisected)
X-Spam-Score: 0.1 (/)
X-Spam-Score-Int: 1
X-Spam-Report: Spam detection software, running on the system "wbs-smtp-out-03.jhb.wbs.co.za", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	Postmaster for details.
	Content preview:  On Sunday 30 March 2008 18:20:49 Marcin Slusarz wrote: > >
	ps: note that offending patch introduced build breakage and the fix was >
	commited 90 revisions later Does 2.6.25-rc1 work for you? That's the first
	broken kernel I've reported for the radio application? [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	0.1 RDNS_DYNAMIC           Delivered to trusted network by host with
	dynamic-looking rDNS
X-Scan-Signature: 934cdb2dba742a9e2c19c05a5bdf244e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 30 March 2008 18:20:49 Marcin Slusarz wrote:
>
> ps: note that offending patch introduced build breakage and the fix was
>     commited 90 revisions later

Does 2.6.25-rc1 work for you? That's the first broken kernel I've reported for 
the radio application?

>
> ps2: i couldn't revert it on top of rc7 because there are many patches
>      which depend on this one
