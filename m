Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZLCHu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZLCHu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 02:50:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZLCHu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 02:50:56 -0500
Received: from mail-yw0-f116.google.com ([209.85.211.116]:55714 "EHLO
	mail-yw0-f116.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZLCHuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 02:50:55 -0500
X-Greylist: delayed 869 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 02:50:55 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=U5sVyfoZ/hAY+mrEsAmwU8sB8XqlKGwRlX0iPuWkasSxwWglWOjuRNWURHqja0WJ2b
         pN15G5/zaBFwP37YOhQMW9qSbV6VtgiGlc7Y3G8nm+fSvjEgKlBY5PqEidTyZzamHy80
         4cUEPWob2qROmuyOU0scinMxFqxiE/VuaTqoI=
Message-ID: <4B176A7F.2060100@garzik.org>
Date: Thu, 03 Dec 2009 02:36:31 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add comment documenting PIO latency issues on
 UP
References: <200911261711.16954.bzolnier@gmail.com>
In-Reply-To: <200911261711.16954.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2009 11:11 AM, Bartlomiej Zolnierkiewicz wrote:
>
> Based on:
> http://lkml.indiana.edu/hypermail/linux/kernel/0908.2/01420.html
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/libata-core.c |    7 +++++++
>   1 file changed, 7 insertions(+)

applied


