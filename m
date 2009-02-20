Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZBTTfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZBTTfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZBTTfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:35:20 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:3924 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbZBTTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:35:18 -0500
MIME-Version: 1.0
In-Reply-To: <20090220192543.GA21644@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
	 <20090220094356.GB26124@silver.sucs.org>
	 <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com>
	 <20090220131209.GA21446@silver.sucs.org>
	 <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com>
	 <20090220142705.GA429@silver.sucs.org>
	 <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
	 <20090220192543.GA21644@silver.sucs.org>
Date: Fri, 20 Feb 2009 20:35:15 +0100
Message-ID: <ac3eb2510902201135x70abdce9n46c7c53a5c04edcd@mail.gmail.com>
Subject: Re: General question (scheduler) with SSDs?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 20:25, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Fri, Feb 20, 2009 at 03:56:06PM +0100, Kay Sievers wrote:
>> Also the whitespace after "...PHISON *" does not need to be matched.
>> If the match value does not end in whitespace itself, udev will match
>> against the value with all trailing whitespace ignored.
>
> Ah, I'm not matching against only whitespace:
>
> $ cat /sys/block/*/device/model
> ASUS-PHISON OB S
> ASUS-PHISON SSD
>
> (the first is the builtin faster SSD, the other is the slower removable
> SSD).

Ah, I see, then nothing to complain from my side anymore. :)

Thanks,
Kay
