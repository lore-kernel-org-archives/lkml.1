Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281Ab0AUESc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0AUESc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:18:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928Ab0AUESa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:18:30 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:35344 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0AUES3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:18:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=inxOD+KOs7AzURyIIUV2XeJAQLjk5/K/9w49F2bRuRmrh1/od5pUD7iwPe9l7YEbth
         V2O7YEEjuTlT/p9F7y2/ksAl5Mmcq/FKv3th22GGovH1EaygGq8Uqn3mtPwSXAMIB98h
         /GXcZ+5UnIU2AfRKX/aarbavtPENVJE3AT/4c=
Message-ID: <4B57D592.4090209@garzik.org>
Date: Wed, 20 Jan 2010 23:18:26 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/64] pata_serverworks: fix PIO setup for the second
 channel
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171638.14623.85773.sendpatchset@localhost>
In-Reply-To: <20100118171638.14623.85773.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:16 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_serverworks: fix PIO setup for the second channel
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_serverworks.c |    3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

applied 19-20


