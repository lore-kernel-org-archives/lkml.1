Return-Path: <linux-kernel-owner+w=401wt.eu-S1762548AbYG3O4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762548AbYG3O4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYG3Ozs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:55:48 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:6638 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761561AbYG3Ozr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=e8vYSiRyXk6e1XYyLY6cxfgADQURYHx0SVCECu/7ojhR2bX+vfZePh8kgh6LxMHhsk
         Rvtm29N8aj/YGGitbzt7y3QnnmStZP64kiBnm9214LSWvdmZHsUtdWfFy4+c41X1E3v2
         wiKmSELcc/8B5+aeAw8rLDHQVDSETuXOyqBrw=
Message-ID: <dd18b0c30807300755y5dace2f0ma5f2c287f33f14d7@mail.gmail.com>
Date: Wed, 30 Jul 2008 07:55:45 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Cc: Komuro <komurojun-mbn@nifty.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <20080730062220.08b2779a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729065859.2bcc65ed@infradead.org>
	 <20080525112308.03a5fda7.komurojun-mbn@nifty.com>
	 <20080729215315.5a505fe7.komurojun-mbn@nifty.com>
	 <16453842.205951217418535898.komurojun-mbn@nifty.com>
	 <20080730062220.08b2779a@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 6:22 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Wed, 30 Jul 2008 20:48:55 +0900 (JST)
> Komuro <komurojun-mbn@nifty.com> wrote:
>
>>
>> >
>> >"I have a hardware failure so I'll comment out the message that says
>> >so, and then I won't have a failure". Yeah that'll work well.
>>
>>
>> O.K. The madwifi should be fixed.
>> Thanks,
>
> madwifi has many bigger issues; it's been number 1 in the kerneloops
> top 10 for months and months now.
>
> Feel free to fix it.. I can't.. it's a proprietary/binary driver.
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I should of written down the error that it was
giving(I can pull again to get the exact error)
from what I remember it was able to do the handshake
but wpa_supplicant would say CTRL-EVENT-CONNECTED then
CTRL-EVENT-DISCONNECTED
if its possible I would like to pull the wireless testing directory
and add that to 2.6.27-rc1. this way I can run ath9k, and the fresh
git "hot out of the oven",
I do have another computer now so reporting problems
makes it a whole lot easier than having one computer.

-- 
Justin P. Mattock
