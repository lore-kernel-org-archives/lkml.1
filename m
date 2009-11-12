Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZKLXxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZKLXxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZKLXxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:53:20 -0500
Received: from rtr.ca ([76.10.145.34]:38947 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755762AbZKLXxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:53:13 -0500
Message-ID: <4AFC9FEC.8030304@rtr.ca>
Date: Thu, 12 Nov 2009 18:53:16 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Thiago Farina <tfransosi@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, jgarzik@pobox.com,
       mlord@pobox.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: Clean up hard coded array size calculation.
References: <1257708657-1232-1-git-send-email-tfransosi@gmail.com>	 <4AF8F363.3010806@rtr.ca> <200911101651.24912.bzolnier@gmail.com>	 <84144f020911100808y55f5bfa2v5c203b356583a7b5@mail.gmail.com>	 <4AFB3C9D.4020609@rtr.ca> <a4c8a6d00911111450y7e451071h3f0ede0a1003678b@mail.gmail.com>
In-Reply-To: <a4c8a6d00911111450y7e451071h3f0ede0a1003678b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thiago Farina wrote:
> On Wed, Nov 11, 2009 at 8:37 PM, Mark Lord <liml@rtr.ca> wrote:
>> Looks like unnecessary churn and obfuscation to me.
> 
> Obfuscation? Are you saying that just because you wrote this code?  So
> what is the usage of a macro? I think you are having a defensive
> position here.
..

No, actually I believe Jeff wrote that particular line of code.

Cheers
