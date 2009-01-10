Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbZAJUYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbZAJUYa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 15:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZAJUYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 15:24:20 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63941 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZAJUYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 15:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VnHKCj3wr0luOT38F2sZ6yvikmgmCmEfIRhDFYAwFF4ifMUzhAM6pHaQlPGOns3pub
         gqa6bR31ldIMMyYzTDe5SZ72nboe+kVLhuCKdv2cpl/25R27rMmRtdIthLHwnXcPGBpa
         cNVYBk/bprKNATW10rtWs9pLG9MlR8NtE4JWg=
Message-ID: <c384c5ea0901101216i8923be7k8d8d9c310f2fba78@mail.gmail.com>
Date: Sat, 10 Jan 2009 21:16:32 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [GIT PULL] Squashfs pull request for 2.6.29
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>,
       "Ingo Molnar" <mingo@elte.hu>, "David Brown" <lkml@davidb.org>,
       "Phil Oester" <kernel@linuxace.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Phillip Lougher" <phillip@lougher.demon.co.uk>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <4968FDA7.5040008@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1LKy3v-0003KO-Nx@dylan.lougher.demon.co.uk>
	 <20090109023629.GA29520@linuxace.com>
	 <20090109165422.GF24884@logfs.org>
	 <20090109193738.GA9827@linode.davidb.org>
	 <20090109211937.GA14342@logfs.org> <20090110124335.GB30744@elte.hu>
	 <20090110165033.GA23943@logfs.org>
	 <20090110101235.7ca24c44.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0901101015290.6528@localhost.localdomain>
	 <4968FDA7.5040008@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jan 10, 2009 at 8:57 PM, Jeff Garzik <jeff@garzik.org> wrote:
>> I think squashfs usage would be similar - you'd not have squashfs as a
>> standalone media, it would be a "installation medium" thing.
>
> Plenty of existing, active squashfs use on router firewall standalone media.
>   Here is my home router running unmodified OpenWRT:
>
> It will be nice to finally get squashfs in the kernel, since it is actively
> used all over the place in embedded projects like OpenWRT.
>
Indeed, in embedded projects squashfs is" Used Everywhere Where Size Matters".
The adds read: "Even my girlfriend recommends it for everyday use."
(At least, that's what I've heard.)

Thanks for the people who could review and make the upcoming merger happen,
and kudos to Phillip.

Regards,
-- 
Leon
