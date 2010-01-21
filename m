Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850Ab0AUEQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab0AUEQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938Ab0AUEQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:16:20 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:38534 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0AUEQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Zvvr+4zo56BV8dgD7b+mk1Fj24YURt23hLAM2OWqCbuWpiHFXSk/M1EJYgl69Owp48
         gJGy9UqwKTN0NEJ4mcw+Ty7vIEUebYiaOKxbx5ZdQHDa1j6L0Gvm1QYrbUVupD0bq3y6
         YYw4Mq5W5lP3VDNyEZNsdubH0eCJT/nA+BpQg=
Message-ID: <4B57D50E.9090907@garzik.org>
Date: Wed, 20 Jan 2010 23:16:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/64] pata_cs5535: use correct values for PIO1 and PIO2
 data timings
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171538.14623.27441.sendpatchset@localhost>
In-Reply-To: <20100118171538.14623.27441.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:15 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_cs5535: use correct values for PIO1 and PIO2 data timings
>
> There shouldn't be any problems with it as IDE cs5535 host driver
> has been using those values for years and they match values given
> in the (publicly available) datasheet.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_cs5535.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

applied 13-14


