Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbXGLGZR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbXGLGZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 02:25:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXGLGZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 02:25:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbXGLGZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 02:25:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Use --build-id ld option
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 11 July 2007 21:48:14 -0700 <4695B28E.2020603@goop.org>
X-Zippy-Says: Yow!  Legally-imposed CULTURE-reduction is CABBAGE-BRAINED!
Message-Id: <20070712062458.6B2BD4D0489@magilla.localdomain>
Date: Wed, 11 Jul 2007 23:24:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Does this mean that performing the same link twice *will* produce an 
> identical result?

Yes.
