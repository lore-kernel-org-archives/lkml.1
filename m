Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZBTSrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZBTSrL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 13:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbZBTSq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 13:46:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZBTSq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 13:46:56 -0500
Date: Fri, 20 Feb 2009 19:46:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zachary Amsden <zach@vmware.com>
Cc: "jeremy@xensource.com" <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Alok Kataria <alokkataria1@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] paravirt-ops maintainers update
Message-ID: <20090220184638.GA18553@elte.hu>
References: <1235158066.6951.127.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235158066.6951.127.camel@bodhitayantram.eng.vmware.com>
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


* Zachary Amsden <zach@vmware.com> wrote:

> Welcome to Alok Kataria, our new paravirt-ops maintainer.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 06e0391..59fd2d1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3334,8 +3334,8 @@ P:	Jeremy Fitzhardinge
>  M:	jeremy@xensource.com
>  P:	Chris Wright
>  M:	chrisw@sous-sol.org
> -P:	Zachary Amsden
> -M:	zach@vmware.com
> +P:	Alok Kataria
> +M:	akataria@vmware.com
>  P:	Rusty Russell
>  M:	rusty@rustcorp.com.au
>  L:	virtualization@lists.osdl.org

Applied to tip:x86/urgent. Welcome Alok!

	Ingo
