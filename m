Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbYDDIzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbYDDIzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 04:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYDDIzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 04:55:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53263 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753757AbYDDIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 04:55:35 -0400
Date: Fri, 4 Apr 2008 10:55:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: agpgart: scary messages are fortunately obsolete
Message-ID: <20080404085520.GA32605@elte.hu>
References: <20080328112507.GA10774@elf.ucw.cz> <20080328113508.GP29105@one.firstfloor.org> <20080401122403.GC12129@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080401122403.GC12129@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2769]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Fix obsolete printks in aperture-64. We used not to handle missing 
> agpgart, but we handle it okay now.

thanks Pavel, applied.

	Ingo
