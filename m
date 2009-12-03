Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZLCW52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZLCW52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZLCW51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:57:27 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:54164 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZLCW50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jbnSqXW7dLAWq4xd2nvMbx77+74BpbNGHOAYKp4yVrVY+TWzT1hpXDYnypQjSxpaUG
         cEk0UkSSN5O5qOsvhRNHGGaoVt20dnrR5w5hGGOw2cFFouSypNY9SYHqYeiUKaZDcTgN
         QvB/vgTY4IOp7QaPVsQAXGxtDyLEsbG+CANUs=
Message-ID: <4B18425A.2020408@garzik.org>
Date: Thu, 03 Dec 2009 17:57:30 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912031339.14440.bzolnier@gmail.com> <4B17FB37.2030501@garzik.org> <200912032045.48728.bzolnier@gmail.com> <4B182A9F.5090708@garzik.org>
In-Reply-To: <4B182A9F.5090708@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 04:16 PM, Jeff Garzik wrote:
>> pata_efar: MWDMA0 is unsupported
>
> skipped, pending discussion (just sent email)

applied, after merging into a single "PIIX no MWDMA0" patch

>> pata_hpt3x2n: fix overclocked MWDMA0 timing
>
> skipped, pending discussion (just sent email)

applied

>> pata_it8213: MWDMA0 is unsupported
>
> skipped, pending discussion (just sent email)

applied

>> pata_oldpiix: MWDMA0 is unsupported
>
> skipped -- Alan, Sergey, comments?

applied, after merging into a single "PIIX no MWDMA0" patch

>> pata_rdc: MWDMA0 is unsupported
>
> skipped -- Alan, Sergey, comments?

applied, after merging into a single "PIIX no MWDMA0" patch

