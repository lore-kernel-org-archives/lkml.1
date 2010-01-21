Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655Ab0AUESv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab0AUESv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396Ab0AUESs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:18:48 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47353 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab0AUESq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=S8koPtz9yOMEEe32T2+65tzKx1r9bpU8jCJlHICOHGTpfE8JoNRi8BojTcHZeqrQX+
         lHiIr+nIAnz0os7L39wWcPUNMcizNB85vr/fuZZYm/Glwe7mFV6U75JcdkDTXO1vaUw3
         Bac5KE1mvTxwyooUlyoO193RELoYU1nwhdVGI=
Message-ID: <4B57D5A4.6050908@garzik.org>
Date: Wed, 20 Jan 2010 23:18:44 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/64] pata_serverworks: cleanup cable detection
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171655.14623.12567.sendpatchset@localhost>
In-Reply-To: <20100118171655.14623.12567.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:16 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_serverworks: cleanup cable detection
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_serverworks.c |   37 +++++++------------------------------
>   1 file changed, 7 insertions(+), 30 deletions(-)

OK but did not apply


