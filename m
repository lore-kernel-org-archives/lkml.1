Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYDDIro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYDDIro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbYDDIrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:47:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45682 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261AbYDDIrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:47:36 -0400
Date: Fri, 4 Apr 2008 10:47:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: Re: [PATCH] x86: remove x86-specific implementations of
	find_first_bit
Message-ID: <20080404084713.GD32209@elte.hu>
References: <20080331171506.GA24017@mailshack.com> <20080401084710.GB4787@elte.hu> <20080401094618.GA24862@mailshack.com> <20080401154126.GA26062@mailshack.com> <20080401154221.GB26062@mailshack.com> <20080401154757.GC26062@mailshack.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401154757.GC26062@mailshack.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0458]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander van Heukelum <heukelum@mailshack.com> wrote:

> [PATCH] x86: remove x86-specific implementations of find_first_bit
> 
> x86 has been switched to the generic versions of find_first_bit and 
> find_first_zero_bit, but the original versions were retained. This 
> patch just removes the now unused x86-specific versions.

thanks Alexander, i've added your patches to x86.git/latest.

	Ingo
