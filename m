Return-Path: <linux-kernel-owner+w=401wt.eu-S1754557Ab0AEDl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0AEDl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 22:41:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754189Ab0AEDl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 22:41:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0AEDlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 22:41:55 -0500
Message-ID: <4B42B3FD.7000608@zytor.com>
Date: Mon, 04 Jan 2010 19:37:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Len Brown <lenb@kernel.org>, Christian Hofstaedtler <ch@zeha.at>,
       x86@kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <alpine.LFD.2.00.1001041632330.4012@localhost.localdomain> <4B42A0CC.2090907@gmail.com>
In-Reply-To: <4B42A0CC.2090907@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 06:15 PM, Robert Hancock wrote:
> 
> Think you mean 2001, Vista was 2006..
> 
> I'm assuming that Windows is using ACPI reset these days, so presumably
> that's what we should be doing by default, and blacklisting machines
> where that doesn't work, rather than the reverse..

Using a DMI cutoff year in the mid-2000's seems like it would make sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

