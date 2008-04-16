Return-Path: <linux-kernel-owner+w=401wt.eu-S1764515AbYDPNId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764515AbYDPNId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 09:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762936AbYDPNIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 09:08:17 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48510 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762714AbYDPNIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:08:16 -0400
Date: Wed, 16 Apr 2008 15:08:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: gart: factor out common code
Message-ID: <20080416130800.GH6304@elte.hu>
References: <20080415104357.GA13441@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415104357.GA13441@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1862]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Cleanup gart handling on amd64 a bit: move common code into 
> enable_gart_translation , and use symbolic register names where 
> appropriate.

thanks Pavel, applied.

	Ingo
