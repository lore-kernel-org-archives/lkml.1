Return-Path: <linux-kernel-owner+w=401wt.eu-S1760168AbYCERW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbYCERW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbYCERWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:22:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:43319 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbYCERWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:22:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z/y4lqp5cqg3IWmDAt/68cpLIemVnql51GlGEwOYDbtlhBMG5158l95QJ8hUwLqMvE/LFsaA4Ksxphe7xnVzhsx4x04NkGUXm788HMeIuAk1R20K6oYCm8NnVjlMVXDP1UZIhit2qQwIxFWh2hNyGpevtYq0TAqrI9jvwdh4kiQ=
Message-ID: <58cb370e0803050922p7695771cq393120ed5906efb7@mail.gmail.com>
Date: Wed, 5 Mar 2008 18:22:13 +0100
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <m3ejap5cvz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	 <20080304173058.7679b7c8.akpm@linux-foundation.org>
	 <20080305115610.397b3ea3@the-village.bc.nu>
	 <200803051421.14167.bzolnier@gmail.com>
	 <m3ir015du5.fsf@maximus.localdomain>
	 <58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com>
	 <m3ejap5cvz.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 5:55 PM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com> writes:
>
>
> > [ Actually, I'm not surprised as we are getting patches/reports for much
>  >   older/buggier hardware...  After all we are doing Linux not some other
>  >   OS whose every release obsoletes the old hardware. ;-) ]
>
>  It isn't just about old/buggy hardware (personally I'm using much
>  older items). The DTLA disks had "rather" short MTBF, with something
>  like 30% returns in the first year after purchase, according to a
>  friendly distributor. Despite firmware upgrades, they were unfixable.

Ah, you meant that it was a DeathStar drive... well, a lucky survivor...
