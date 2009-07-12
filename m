Return-Path: <linux-kernel-owner+w=401wt.eu-S1753097AbZGLUHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbZGLUHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 16:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbZGLUHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 16:07:04 -0400
Received: from n26.bullet.mail.mud.yahoo.com ([68.142.206.221]:46244 "HELO
	n26.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751241AbZGLUHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 16:07:03 -0400
X-Yahoo-Newman-Id: 307731.60581.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LhizeH8xA4olCCjD/HVCn1gpkWYgS/nDqL0FZlEZnD7/VfZFVMsnEta3Kr4haKYSymD30+IAoDOrUd38RnL5b7waaJiRpNgStnhDqXf86QbUtkeL8+TIOiR0XEVmkL18/uvevW/KpIyxv4WFHrfZWSyrABWC6DUgwSEoldYewUI=  ;
X-YMail-OSG: RNI.RD8VM1lvK2TwDEaN.0koY42qxQhVBz9ftTDPB5vPolVrv70ciabgcyaGelYz4tku2xCCVB6CY8mKxDUd.ktnTPkyRjqco5UTeV.LhpXNDY0Cc4Sj.VIjFh1L7lnxThS8FrOTpqHHbUTWGoVPLzp3STjPC.2atTuDodq78OUU69c1Ys6n8WIOIqtKkqYMZ26dA7HKFcsWZoF0MtMW3aUxZp0dPZhxkBmC2jTJkuuc0QFU6ENHd6Su1U99no5hXMuTMad9BoDQ0hOq67wxVQ6ZaA9PtVsSTSs1.tXWB4qIBNoUKJU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sun, 12 Jul 2009 13:07:00 -0700
User-Agent: KMail/1.9.10
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <20090712084734.GA944@flint.arm.linux.org.uk> <20090712131732.GA4406@flint.arm.linux.org.uk>
In-Reply-To: <20090712131732.GA4406@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907121307.01216.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Russell King wrote:
> Here is the effect of applying the am79c961 patch:

Observe:  $SUBJECT is an entirely separate patch.

My NAKs were quite specific.

