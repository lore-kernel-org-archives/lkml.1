Return-Path: <linux-kernel-owner+w=401wt.eu-S1760384AbZCPSPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384AbZCPSPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZCPSPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:15:38 -0400
Received: from mx1.wp.pl ([212.77.101.5]:61294 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977AbZCPSPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:15:37 -0400
Date: Mon, 16 Mar 2009 19:21:56 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-sound@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix NULL dereference when suspending snd_opl3sa2
Message-Id: <20090316192156.80709aff.krzysztof.h1@wp.pl>
In-Reply-To: <1237212968.11067.3.camel@localhost.localdomain>
References: <1237197709.7210.2.camel@localhost.localdomain>
	<1237212968.11067.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [EVP0]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 15:16:08 +0100
Lubomir Rintel <lkundrak@v3.sk> wrote:

> On Mon, 2009-03-16 at 11:01 +0100, Lubomir Rintel wrote:
> > This should fix the following OOPS:
> > http://www.kerneloops.org/raw.php?rawid=80591&msgid=
> 

> 
> This is the same issue, with 2.6.28:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=519939
> 
> 

I'll look into this.

Regards,
Krzysztof
