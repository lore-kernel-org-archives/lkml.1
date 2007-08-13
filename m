Return-Path: <linux-kernel-owner+w=401wt.eu-S1030741AbXHMM5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741AbXHMM5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965433AbXHMHvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:51:43 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:47291 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S942917AbXHMHvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:51:39 -0400
Message-ID: <46C00D86.4090403@dgreaves.com>
Date: Mon, 13 Aug 2007 08:51:34 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Paul Clements <paul.clements@steeleye.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, david@lang.hm,
       Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: [RFD] Layering: Use-Case Composers (was: DRBD - what is it,	anyways?
 [compare with e.g. NBD + MD raid])
References: <200708121335.17267.a1426z@gawab.com> <Pine.LNX.4.64.0708121325170.28963@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708120933210.19502@asgard.lang.hm> <Pine.LNX.4.64.0708121901290.28963@fbirervta.pbzchgretzou.qr> <20070812174549.GA2915@teal.hq.k1024.org> <46BFB6BB.80406@steeleye.com>
In-Reply-To: <46BFB6BB.80406@steeleye.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Clements wrote:
> Well, if people would like to see a timeout option, I actually coded up 
> a patch a couple of years ago to do just that, but I never got it into 
> mainline because you can do almost as well by doing a check at 
> user-level (I basically ping the nbd connection periodically and if it 
> fails, I kill -9 the nbd-client).


Yes please.

David

