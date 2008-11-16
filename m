Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYKPDD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYKPDD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 22:03:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYKPDDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 22:03:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:48768 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbYKPDDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 22:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references
         :disposition-notification-to:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=mLekU5/inkYN3zTMNDGFerU2MmsREFdZoiKK33BynQGAd93JCMJYxSxMGzsUY9PHns
         06t/kj4aRuilnNnQDpts1Ho+oYAEn32Qfb2IeO64zdkZwL4FDTE0b/pGlJ8gXLH8URew
         /utqG35tEm2rnudUCahMssmVRHps8SMWmmcFo=
Subject: Re: kernel suddenly fails to boot
From: Tamber Krain <james.penketh@googlemail.com>
To: Felix von Leitner <felix-linuxkernel@fefe.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081116021537.GA32090@codeblau.de>
References: <20081116021537.GA32090@codeblau.de>
Content-Type: text/plain
Date: Sun, 16 Nov 2008 03:03:32 +0000
Message-Id: <1226804615.17980.12.camel@furryhelix.webhop.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I have four gigs of RAM in the box, Windows XP only uses 3.25 of those.
> Could this be a problem on the remaining RAM?

This is not a problem with the RAM, a 32-bit OS will only see that
amount of RAM maximum. (Although PAE will let it see more, IIRC. Could
be wrong though.)


