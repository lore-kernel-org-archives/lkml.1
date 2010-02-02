Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0BBX0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:26:35 -0500
Received: from fifo99.com ([67.223.236.141]:40620 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab0BBX0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:26:32 -0500
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 18:26:32 EST
Subject: Re: [RFC PATCH V2] checkpatch.pl: Add warning on non #define 
 continuation lines
From: Daniel Walker <dwalker@fifo99.com>
To: Joe Perches <joe@perches.com>
Cc: John Kacur <jkacur@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1265150077.1945.137.camel@Joe-Laptop.home>
References: <cover.1264967493.git.joe@perches.com>
	 <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
	 <20100201144745.GC26011@rakim.wolfsonmicro.main>
	 <1265044080.25140.266.camel@Joe-Laptop.home>
	 <8bd0f97a1002012013t5c4a3951ra559a8965d67a672@mail.gmail.com>
	 <20100202110824.GF6566@rakim.wolfsonmicro.main>
	 <1265115344.25140.805.camel@Joe-Laptop.home>
	 <520f0cf11002020549td6bb27fp9301d3385dc6a0e3@mail.gmail.com>
	 <1265150077.1945.137.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Feb 2010 15:18:46 -0800
Message-ID: <1265152726.21489.19.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 14:34 -0800, Joe Perches wrote:

> There's probably something more appropriate that Andy Whitcroft
> could work out that actually apply patches and verifies the
> code using something like the ctx_statement_block functions but
> that code is overly mysterious to me.
> 
> Does anyone know if Andy Whitcroft is still looking after checkpatch?

He's often slow to respond ..

Daniel


