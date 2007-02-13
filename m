Return-Path: <linux-kernel-owner+w=401wt.eu-S1750908AbXBMUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbXBMUEv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750915AbXBMUEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:04:51 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:55064 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbXBMUEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:04:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hwWiDYe/SFdVsilTGXa6fNXEydZ1IeOf2aMxmIBK9keVipw1WNBztvinR3xO3sGeUuHUwuUEy2ImBZiYE3uKGKfxjTr47lPQaxaZaWVckYb0WEQFAOtO5oHbIEVdfhzFbNEJHP870SD/pjV94wfMbN6T1dp4nKBmX1L4hjo2aA0=
Message-ID: <8d158e1f0702131204l51099b84m822aba87ffb64ccb@mail.gmail.com>
Date: Tue, 13 Feb 2007 21:04:47 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [LIBATA] Libata under Qemu
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070213195933.GC16991@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702130955n1ae4ebbew4bbf799d683c79fc@mail.gmail.com>
	 <8d158e1f0702131153g6d9f748djb7556a1e9ebc71ad@mail.gmail.com>
	 <20070213195933.GC16991@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Jeff Garzik <jeff@garzik.org> wrote:

>
> /That/ sounds like a qemu bug.

Allright, I will make sure tonight by testing it on a native PIIX
mainboard without anything connected to the second PATA controller :)

I thought for a second it was a similar "abnorma statel" error I got
earlier this week with pata_via when no drive was attached (no qemu,
real hardware)

I'll keep you posted.


Patrick
