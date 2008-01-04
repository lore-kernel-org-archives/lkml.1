Return-Path: <linux-kernel-owner+w=401wt.eu-S1758667AbYADJHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667AbYADJHL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 04:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYADJGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 04:06:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41819 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbYADJGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 04:06:54 -0500
Date: Fri, 4 Jan 2008 10:06:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86] [8/16] Make lockdep_init __init
Message-ID: <20080104090643.GG28740@elte.hu>
References: <20080103442.621670000@suse.de> <20080103154222.2C75314DDB@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080103154222.2C75314DDB@wotan.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> Make lockdep_init __init
> 
> Cc: peterz@infradead.org
> Signed-off-by: Andi Kleen <ak@suse.de>

thanks, applied the bits that did not depend on the early-reservations 
changes.

	Ingo
