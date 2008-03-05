Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYCEQzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYCEQzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759950AbYCEQzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:55:31 -0500
Received: from khc.piap.pl ([195.187.100.11]:55051 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759938AbYCEQza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:55:30 -0500
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrew Morton" <akpm@linux-foundation.org>, jeff@garzik.org,
       linux-ide@vger.kernel.org, alan@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] pata: "I do not think it means, what you think it means."
References: <200803042316.m24NGI7k002489@imap1.linux-foundation.org>
	<20080304173058.7679b7c8.akpm@linux-foundation.org>
	<20080305115610.397b3ea3@the-village.bc.nu>
	<200803051421.14167.bzolnier@gmail.com>
	<m3ir015du5.fsf@maximus.localdomain>
	<58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 05 Mar 2008 17:55:28 +0100
In-Reply-To: <58cb370e0803050846t7dbd65d6ocfec7ca5e93aa6db@mail.gmail.com> (Bartlomiej Zolnierkiewicz's message of "Wed\, 5 Mar 2008 17\:46\:08 +0100")
Message-ID: <m3ejap5cvz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com> writes:

> [ Actually, I'm not surprised as we are getting patches/reports for much
>   older/buggier hardware...  After all we are doing Linux not some other
>   OS whose every release obsoletes the old hardware. ;-) ]

It isn't just about old/buggy hardware (personally I'm using much
older items). The DTLA disks had "rather" short MTBF, with something
like 30% returns in the first year after purchase, according to a
friendly distributor. Despite firmware upgrades, they were unfixable.
-- 
Krzysztof Halasa
