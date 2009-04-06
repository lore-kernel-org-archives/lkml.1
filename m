Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZDFHdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZDFHdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 03:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZDFHcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 03:32:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52266 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZDFHcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 03:32:46 -0400
Message-ID: <49D9B017.4080807@vlnb.net>
Date: Mon, 06 Apr 2009 11:32:39 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: ronnie sahlberg <ronniesahlberg@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scst-devel <scst-devel@lists.sourceforge.net>,
       iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [ANNOUNCE]: Comparison of features sets between different SCSI
 	targets (SCST, STGT, IET, LIO)
References: <49D7AD54.4060408@vlnb.net> <c9a3e4540904052019o3c89128eq52d9046fef7e2725@mail.gmail.com>
In-Reply-To: <c9a3e4540904052019o3c89128eq52d9046fef7e2725@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX185Oy4T5kyq+JsNiwt/qbO2eKg+BdXUHmzpKK5
 dpENWcKaHdpn1gn7pKs9wuxv07XkdpsgSyPWNP4+Ze37a7OA4P
 BpziaRGjd65pJvGQiikQQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ronnie sahlberg, on 04/06/2009 07:19 AM wrote:
> Maybe you should also show which device types each implementation can 
> emulate.

OK. Seems I should add than STGT has additional emulation for SMC and 
SSC devices as "Under development", correct?

> On Sun, Apr 5, 2009 at 5:56 AM, Vladislav Bolkhovitin <vst@vlnb.net 
> <mailto:vst@vlnb.net>> wrote:
> 
>     Hi All,
> 
>     I set up http://scst.sourceforge.net/comparison.html page, which
>     compares features of existing SCSI target subsystems for Linux. The
>     comparison includes SCST, STGT, IET and LIO.
> 
>     I might be not fully correct somewhere, so, if you don't agree with
>     me about some item(s) in the comparison table, please let me know
>     and I will fix that.
> 
>     Vlad
>     --
>     To unsubscribe from this list: send the line "unsubscribe stgt" in
>     the body of a message to majordomo@vger.kernel.org
>     <mailto:majordomo@vger.kernel.org>
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

