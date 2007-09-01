Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXIAU6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXIAU6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 16:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755784AbXIAU6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 16:58:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57913 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbXIAU6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 16:58:05 -0400
Message-ID: <46D9D23A.8050704@zytor.com>
Date: Sat, 01 Sep 2007 21:57:30 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Shane <shane@cm.nu>, linux-kernel@vger.kernel.org
Subject: Re: intel-rng on modern hardware
References: <20070901194426.GA32713@csy.ca> <46D9CE20.9060603@garzik.org>
In-Reply-To: <46D9CE20.9060603@garzik.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Shane wrote:
>> Just wondering if there is a newer version of intel-rng out
>> of tree or whether modern Intel chipsets have a usable RNG. I haven't 
>> been able to get intel-rng loading (no such
>> device) on anything from the p965, p975 or p35 chipsets.
> 
> No modern ICH chipset has an RNG, AFAIK.
> 

Which is a major lossage :(

	-hpa

