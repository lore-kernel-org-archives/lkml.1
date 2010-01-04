Return-Path: <linux-kernel-owner+w=401wt.eu-S1753608Ab0ADRfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab0ADRfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409Ab0ADRfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:35:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39847 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab0ADRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:35:40 -0500
Message-ID: <4B4225B3.8070705@zytor.com>
Date: Mon, 04 Jan 2010 09:30:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2010 09:15 AM, Len Brown wrote:
> 
> I believe that Venki is sending a patch to make all recent
> motherboards use acpi reset by default; and I'd rather
> see that kind of patch than this one.
> 
> I've had the patch below patch in acpi-test, and thus linus-next,
> and -mm since Nov 2008 to change the default for
> all systems w/ no issues.
> 

Maybe I'm misremembering, but didn't we have to pull this patch after it
hit mainstream the last time?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

