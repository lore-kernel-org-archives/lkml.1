Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZAOFh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZAOFh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 00:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZAOFhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 00:37:47 -0500
Received: from wf-out-1314.google.com ([209.85.200.172]:9012 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZAOFhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 00:37:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WcpcIry3Xxli7/gxiyg/kU/YjWDlL/x++44xhVjbL/fr8TA8lvEELldU16sXn2B88l
         VrKKeGvadFm9XvL90pEbK+tGB6GBXccw28Cqq8aacCYN8kYQ3/87Mw40UnybVppkg2dR
         bvXn3kLEXc0KDXSrTCgSSNFFZGsOzUCZHlA8E=
Message-ID: <496ECBA0.60209@gmail.com>
Date: Thu, 15 Jan 2009 14:37:36 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Michael Tokarev <mjt@tls.msk.ru>, Jens Axboe <jens.axboe@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through	sysfs
References: <200901051952.58029.bzolnier@gmail.com>	 <20090105185428.GS32491@kernel.dk>	 <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com>	 <20090106073515.GY32491@kernel.dk>  <4964866D.8010503@msgid.tls.msk.ru> <1231342473.3282.19.camel@localhost.localdomain>
In-Reply-To: <1231342473.3282.19.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

James Bottomley wrote:
> I'm afraid that's pretty much marketing coolaid.  Rotational storage
> will dominate for the forseeable future: just do a simple back of the
> envelope calculation:

Or just compare prices per byte of memory, flash and rotation disk.
They haven't had changed too much during last several years.
Secondary storage which is only slightly cheaper than the primary
storage doesn't have much chance of flying high and far.

Thanks.

-- 
tejun
