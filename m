Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbZBDVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbZBDVUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZBDVUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:20:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40518 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZBDVUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:20:12 -0500
Date: Wed, 4 Feb 2009 22:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: petkovbb@gmail.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/Kconfig.cpu: make Kconfig help readable in the
	console
Message-ID: <20090204212000.GL22608@elte.hu>
References: <20090204204404.GA28323@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204204404.GA28323@gollum.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Borislav Petkov <petkovbb@googlemail.com> wrote:

> From: Borislav Petkov <petkovbb@gmail.com>
> Date: Wed, 4 Feb 2009 21:14:50 +0100
> Subject: [PATCH] x86/Kconfig.cpu: make Kconfig help readable in the console
> 
> Impact: cleanup
> 
> Some lines exceed the 80 char width making them unreadable.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  arch/x86/Kconfig.cpu |   30 ++++++++++++++++--------------
>  1 files changed, 16 insertions(+), 14 deletions(-)

good catch - applied to tip:x86/urgent, thanks Borislav!

	Ingo
