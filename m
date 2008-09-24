Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbYIXJhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbYIXJhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYIXJhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:37:10 -0400
Received: from ns2.mvista.com ([63.81.120.155]:58591 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752136AbYIXJhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:37:08 -0400
Message-ID: <48DA0A39.3070308@ru.mvista.com>
Date: Wed, 24 Sep 2008 13:36:57 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: petkovbb@gmail.com, bzolnier@gmail.com, Mark de Wever <koraq@xs4all.nl>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Gadi Oxman <gadio@netvision.net.il>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com> <20080923074845.GB5656@gollum.tnic> <20080923165914.GA7803@localhost> <20080924071055.GB16949@gollum.tnic>
In-Reply-To: <20080924071055.GB16949@gollum.tnic>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Borislav Petkov wrote:

> Bart,
>
> please apply the following patch.
>
> @Sergei: would you like to add your Signed-off-by too?
>   

   Just my ACK.

> --
> Subject: ide-tape: fix vendor strings
>
> Remove superfluous two bytes from each string buffer and add proper length
> format specifiers.
>
> There should be no functional change resulting from this patch.
>
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> Tested-by: Mark de Wever <koraq@xs4all.nl>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


