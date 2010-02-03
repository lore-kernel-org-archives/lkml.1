Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab0BCT6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:58:13 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:54399 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab0BCT6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:58:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lD74FrNwNfXrlFqNJNLDIgcGTvMVOPeFKe/ABZWKHhR6N1o92IqkD3+jsv7gjHWsMc
         pFTVjFu3VioBH4cTFDSecKLpzIEoAg/zG81hSvVqBeJ3whxoeI1dXLw6gWOeo4vRa7wB
         AmacL70vT974HhESDpsGnMxPD+MlZyoJaOBt8=
Message-ID: <4B69D54F.4040705@garzik.org>
Date: Wed, 03 Feb 2010 14:58:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Abraham <thomas.ab@samsung.com>, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org,
       Thomas Chou <thomas@wytron.com.tw>,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [git patches] new hardware support for atang tree
References: <201002031940.20129.bzolnier@gmail.com>
In-Reply-To: <201002031940.20129.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 01:40 PM, Bartlomiej Zolnierkiewicz wrote:
>
> Since I haven't seen any progress on mainstreaming of s3c-ide and
> pata_altera_cf patches in the recent months I decided to merge them

pata_altera_cf still needs to be updated to v3, taking into account 
Alan's feedback.  A ping in Nov 2009 resulted in no response.

	Jeff





