Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbYBOSlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbYBOSlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:41:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756349AbYBOSln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:41:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186AbYBOSlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:41:42 -0500
Message-ID: <47B5DCE2.6020802@zytor.com>
Date: Fri, 15 Feb 2008 10:41:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dan Gora <dan.gora@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: PCI Bursting with PIO
References: <4779de450802141928led16cebkfb989551eb88a8cb@mail.gmail.com>	 <20080215130244.780285cf@core> <4779de450802151000o2c06df0fq6d0daa22c43b935b@mail.gmail.com>
In-Reply-To: <4779de450802151000o2c06df0fq6d0daa22c43b935b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Gora wrote:
>>
>>  Put a DMA controller on it ;)
> 
> Ugh.. sadly that's what's coming.  I really don't get why the
> northbridge cannot burst however.

Because the early Intel northbridges didn't, so noone else bothered 
either, since everyone designed their hardware to not require that 
capability.

	-hpa
