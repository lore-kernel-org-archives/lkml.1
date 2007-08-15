Return-Path: <linux-kernel-owner+w=401wt.eu-S1760546AbXHOJS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760546AbXHOJS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 05:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXHOJSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 05:18:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:56330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbXHOJSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 05:18:16 -0400
From: Andreas Schwab <schwab@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jason Uhlenkott <jasonuhl@jasonuhl.org>,
       Arjan van de Ven <arjan@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: kfree(0) - ok?
References: <46C233CB.9000602@am.sony.com>
	<1187132149.2618.2.camel@laptopd505.fenrus.org>
	<20070814232107.GA4265@aurum.uhlenkott.net>
	<Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
X-Yow: Now that we're in LOVE, you can BUY this GOLDFISH for a 48% DISCOUNT.
Date: Wed, 15 Aug 2007 11:18:09 +0200
In-Reply-To: <Pine.LNX.4.64.0708150928200.19270@fbirervta.pbzchgretzou.qr>
	(Jan Engelhardt's message of "Wed\, 15 Aug 2007 09\:28\:54 +0200 \(CEST\)")
Message-ID: <jelkcdf966.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Aug 14 2007 16:21, Jason Uhlenkott wrote:
>>On Tue, Aug 14, 2007 at 15:55:48 -0700, Arjan van de Ven wrote:
>>> NULL is not 0 though.
>>
>>It is.  Its representation isn't guaranteed to be all-bits-zero,
>
> C guarantees that.

Linux C does it.  But not Standard C.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
