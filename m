Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbXJON5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbXJON5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 09:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763866AbXJON46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 09:56:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:12194 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763212AbXJON4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 09:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=FBTrmtwW7z6rSlg4QAEK/cUC2GVaHBYPKYRQDn/5vtB8UaeFp5U6WZrmlECI3KEd5COfz9hYFWubSlwLqXzVpiocZm+ivE6+6K17HOcdCLI7MVj1om5kJKx83Fsgb+EwUzgVtQ2RI1yyHyZ2c0xKN0Hkdgkxxws4ZPM1pbB1Y7U=
Message-ID: <471370C4.8000803@googlemail.com>
Date: Mon, 15 Oct 2007 15:53:08 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hannes Reinecke <hare@suse.de>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
References: <200710141558.27156.vda.linux@googlemail.com> <47125633.3030404@googlemail.com>
In-Reply-To: <47125633.3030404@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Compile tested and applies cleanly to 2.6.23.
>> I don't have this hardware anymore and cannot run test these patches.
> 
> I can test these patches on an aic7892 controller later on today if you want.

Works fine for me tested on :

03:0e.0 SCSI storage controller [0100]: Adaptec AIC-7892P U160/m [9005:008f] (rev 02)


Gabriel
