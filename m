Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZKEUpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZKEUpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758852AbZKEUpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:45:25 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39095 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758775AbZKEUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mflFpfpxdSI0r2Y2+j73EEDJnGhifeGemQuySl64oUJgPFGIsZSKUFwQ67FVfKRi/5
         NEBFGAZjmtbw66d7kLZ06ND2QbrLuk9gK8aeVHfRn0n9UJghLSSqLI/2HnkgTR6MLryy
         Tf04iPEl6buTbUxoNNIfV9QFmDHZwioMeL3eg=
Message-ID: <4AF33965.9090708@gmail.com>
Date: Thu, 05 Nov 2009 21:45:25 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090926 Lightning/1.0pre Shredder/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 37/41] rt2x00: remove needless ifdefs from rt2x00leds.h
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain> <20091104173633.28463.3378.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173633.28463.3378.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/09 18:36, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] rt2x00: remove needless ifdefs from rt2x00leds.h
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---

For what it is worth:

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

