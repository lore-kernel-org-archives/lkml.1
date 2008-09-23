Return-Path: <linux-kernel-owner+w=401wt.eu-S1752256AbYIWONV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbYIWONV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYIWONI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:13:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56960 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381AbYIWONH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:13:07 -0400
Date: Tue, 23 Sep 2008 16:12:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oruba <peter.oruba@amd.com>, Arjan van de Ven <arjan@infradead.org>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [PATCH] x86, microcode rework, v2, renaming cont.
Message-ID: <20080923141255.GA14041@elte.hu>
References: <b647ffbd0809230212s41d2ef90u2915e40128b254e3@mail.gmail.com> <200809231436.m8NEaNlM030319@elemente.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231436.m8NEaNlM030319@elemente.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oruba <peter.oruba@amd.com> wrote:

> Renaming based on patch from Dmitry Adamushko.
> 
> Further clarification by renaming define and variable related to
> microcode container file.
> 
> Signed-off-by: Peter Oruba <peter.oruba@amd.com>

applied to tip/x86/microcode, thanks Peter!

Arjan: could you check whether latest tip/master fixes the microcode 
initrd problem you reported?

	Ingo
