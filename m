Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbYE1NgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbYE1NgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYE1NgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:36:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:55990 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYE1NgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=EeIMkQH11Q/WfP8s4BUoKo0BI/wrTC5xCdb278G55V3HVAygNoy1W6LCmKlDoCXETzi0ZMA29mqCc9GX8rIM37rdgdR3qjUuN1LcnlRNuIeU9kyjHKNUn5kM9lSo5EhrN4PDWilno1pGu7y0XPGCsMLYMe7Za26pAeNLt6aEBcw=
Message-ID: <8dacd7b30805280636p34097a84t6f7e5c7ebe98747a@mail.gmail.com>
Date: Wed, 28 May 2008 15:36:12 +0200
From: "Jan Niklas Hasse" <jhasse@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: libata - DMA problems ICH7 rev 02
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <8dacd7b30805280634s77492f0ag15ee65150f8bedad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.6VoLd5Q2gfHHZZfYneNkQcGjXKk@ifi.uio.no>
	 <fa.kzdMLVO0bqLAbXEBqWrKyBntgxc@ifi.uio.no>
	 <fa.h4D6h2c4Yz08K7snVTVtewbsziM@ifi.uio.no> <481BD00E.7050302@shaw.ca>
	 <8dacd7b30805120855q406f566ma187142719bf5bd4@mail.gmail.com>
	 <4828DEE1.1070905@shaw.ca>
	 <8dacd7b30805280634s77492f0ag15ee65150f8bedad@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2008 at 3:34 PM, Jan Niklas Hasse <jhasse@gmail.com> wrote:
>>
>> It looks like you have the hard drive and the burner on the same IDE channel? Such problems are unavoidable in this setup since commands to one device on the channel can't execute while the other device is busy (especially for long commands like finalizing the disc). It would be better to move the drives onto separate channels.
>

As I have a notebook, I think I can't do that, can I?
