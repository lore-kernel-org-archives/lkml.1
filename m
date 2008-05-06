Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYEFM3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYEFM3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 08:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYEFM27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 08:28:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41800 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbYEFM26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 08:28:58 -0400
Date: Tue, 6 May 2008 14:28:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: travis@sgi.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: Unify current.h
Message-ID: <20080506122841.GK32591@elte.hu>
References: <Pine.LNX.4.64.0805051146210.11469@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805051146210.11469@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Christoph Lameter <clameter@sgi.com> wrote:

> There are just two definitions that are shared but the resulting 
> combined file is resonably small. Putting these two arch headers 
> together shows that further unifications requires a unification of the 
> per cpu / pda handling between both arches (zero based or some 
> variation thereof).
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

applied, thanks Christoph.

	Ingo
