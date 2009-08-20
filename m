Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZHTUbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZHTUbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 16:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755294AbZHTUbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 16:31:18 -0400
Received: from bar.sig21.net ([80.81.252.164]:56164 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbZHTUbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 16:31:17 -0400
Date: Thu, 20 Aug 2009 22:32:40 +0200
From: Johannes Stezenbach <js@sig21.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bob Copeland <me@bobcopeland.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [Bug #13948] ath5k broken after suspend-to-ram
Message-ID: <20090820203240.GB4444@sig21.net>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
 <ADSuNT6McuD.A.IT.5NIjKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADSuNT6McuD.A.IT.5NIjKB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.6 (---)
X-Spam-21-Report: No, score=-3.6 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.791,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 10:26:59PM +0200, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13948
> Subject		: ath5k broken after suspend-to-ram
> Submitter	: Johannes Stezenbach <js@sig21.net>
> Date		: 2009-08-07 21:51 (13 days old)
> References	: http://marc.info/?l=linux-kernel&m=124968192727854&w=4
> Handled-By	: Nick Kossifidis <mickflemm@gmail.com>
> Patch		: http://patchwork.kernel.org/patch/38550/

I cannot test this at the moment, but there have been no
changes to ath5k since I reported the bug, and the
patch still applies.  Please keep this listed.


Thanks
Johannes
