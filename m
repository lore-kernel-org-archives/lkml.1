Return-Path: <linux-kernel-owner+w=401wt.eu-S1763459AbXLTXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763459AbXLTXH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 18:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbXLTXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 18:07:16 -0500
Received: from pat.uio.no ([129.240.10.15]:40740 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005AbXLTXHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 18:07:14 -0500
Subject: Re: Linux 2.6.24-rc5 x86 architecture no longer Oopses...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071220145621.90ffb08a.akpm@linux-foundation.org>
References: <1198190447.29917.9.camel@heimdal.trondhjem.org>
	 <20071220145415.f737e7f3.akpm@linux-foundation.org>
	 <20071220145621.90ffb08a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 20 Dec 2007 18:06:24 -0500
Message-Id: <1198191984.31865.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.3, required=5.0, autolearn=disabled, AWL=-0.344)
X-UiO-Scanned: 60135CFE0CCDA24AD31FE87A7E3FCFA78F41C013
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -2 maxlevel 200 minaction 2 bait 0 mail/h: 55 total 5853144 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-20 at 14:56 -0800, Andrew Morton wrote:
> btw, I think we should track this as a regression, please.  It may not
> strictly be a regression: the same problem might happen under 2.6.23,
> although reports are only agaisnt 2.6.24-rc.
> 
> But things which impact our ability to get clean oops reports are critical
> problems.

I second that opinion...

Trond

