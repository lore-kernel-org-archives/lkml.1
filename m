Return-Path: <linux-kernel-owner+w=401wt.eu-S1752549AbZGWK3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549AbZGWK3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbZGWK3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:29:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:4046 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZGWK3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:29:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pLvKWvh/W1CLsOGWwoBmSxqlV9ZOP+lK+FN6NE3a9vlHGS+TfenhHTNrAZ8Fto6cqW
         2JuIbcVaQnN5YF4EIlPuYLXElpd5B1QPGJ9BOldjYxbq3JNCmoDRjscBz/AD0RlBfb6u
         4s9e6yyQgIyS+wY3oEriR/r1FWjkn+bnk50kc=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0907171626330.4731@axis700.grange>
References: <Pine.LNX.4.64.0907170842050.4731@axis700.grange>
	 <aec7e5c30907170719re0b4152y987d30f8cdeb0cba@mail.gmail.com>
	 <Pine.LNX.4.64.0907171626330.4731@axis700.grange>
Date: Thu, 23 Jul 2009 19:29:07 +0900
Message-ID: <aec7e5c30907230329p19be67ccxfbffb8956922fb8c@mail.gmail.com>
Subject: Re: [PATCH] MMC: Make the configuration memory resource optional
From: Magnus Damm <magnus.damm@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Ian Molton <ian@mnementh.co.uk>, linux-kernel@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>, Magnus Damm <damm@opensource.se>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added akpm to the CC]

On Fri, Jul 17, 2009 at 11:34 PM, Guennadi
Liakhovetski<g.liakhovetski@gmx.de> wrote:
> (forgot the "[PATCH]" marker on submission, re-added now)
>
> On Fri, 17 Jul 2009, Magnus Damm wrote:
>
>> On Fri, Jul 17, 2009 at 8:10 PM, Guennadi
>> Liakhovetski<g.liakhovetski@gmx.de> wrote:
>> > Add support for tmio_mmc hardware configurations, that lack the cnf io
>> > area, like SuperH SoCs. With this patch such hardware can pass a single
>> > ctl io area with the platform data.
>>
>> Right, this need looks familiar. =)
>
> Your Acked-by would be appreciated:-)

Since this is a hobby project I prefer to sign off with my swedish address:

Acked-by: Magnus Damm <damm@opensource.se>

>> Have you tested this on any specific platform?
>
> Yep, on migor with the sh7722 CPU.

I've tested it on Migo-R as well and all seems fine.

Can someone please pick this up? akpm? =)

Thanks for your help!

/ magnus
