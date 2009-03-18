Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbZCRB60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbZCRB60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbZCRB6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:58:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:9008 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbZCRB6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:58:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ev5ipoxGpXdIVc4IG2/C52efXu1x0pEfOpZv4Q7C9Vp2cYRKpzFAQI5Ghu1mRQ8PjW
         T00LjVC4Op5iyPAcekGk7D0jJykMhBenOFWZOf1KzhgREPXcJwNp/6kYvay+BJ3R9vpb
         cZ5C5PG9hJTbC7+hTfy4w901rb+/Y8PyOZftk=
MIME-Version: 1.0
In-Reply-To: <20090316193010.56644165@mjolnir.ossman.eu>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
	 <20090316193010.56644165@mjolnir.ossman.eu>
Date: Wed, 18 Mar 2009 01:58:13 +0000
Message-ID: <aec7e5c30903171858w12a9ee5bl4f3590d1a25a9971@mail.gmail.com>
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
From: Magnus Damm <magnus.damm@gmail.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx, ian@mnementh.co.uk,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/09, Pierre Ossman <drzeus@drzeus.cx> wrote:
> On Wed, 11 Mar 2009 21:58:45 +0900
>  Magnus Damm <magnus.damm@gmail.com> wrote:
>
>  > tmio_mmc: Minor fixes and cnf/irq changes

>  > [PATCH 01/05] tmio_mmc: Fix one off, use resource_size() in probe()
>  > [PATCH 02/05] tmio_mmc: Fix use after free in remove()
>  > [PATCH 03/05] tmio_mmc: Break out cnf area operations
>  > [PATCH 04/05] tmio_mmc: Make cnf area optional
>  > [PATCH 05/05] tmio_mmc: Support multiple interrupts
>  >
>  > Signed-off-by: Magnus Damm <damm@opensource.se>

> I've queued up patch one and two for now. Thanks.

Thanks for your help. I was hoping on getting patch 3 and 4 included
in 2.6.30 as well if possible. I suspect that i have to rework them a
bit first though. That's no problem. Just let me know how you guys
prefer things and i'll resend.

/ magnus
