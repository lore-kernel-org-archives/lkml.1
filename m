Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbZECQ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbZECQ2b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZECQ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 12:28:18 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58958 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZECQ2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 12:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=YfjsyRHw6j2/LziKCew262NnxVi03Q23AatFJFuFXbdmovKCVu9b57TtMGto218g/t
         hvI+7Cyh1cAWl1qEATgcXgziaogQ1yHIE6Hm7GjNW/wxF1ooQwHQO3YCvVMdIIN/dFMF
         VZGgAkbjalG5ZPt3vltoUYZfesjYNDEuHMpzA=
From: Florian Fainelli <florian@openwrt.org>
To: Francis Moreau <francis.moro@gmail.com>, netdev@vger.kernel.org
Subject: Re: v2.6.30-rc4: b44: eth0: BUG! Timeout waiting for bit 00000002 of  register 42c to clear.
Date: Sun, 3 May 2009 18:28:14 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <38b2ab8a0905030922x722a45f3gf0790b5b90b0f2b3@mail.gmail.com>
In-Reply-To: <38b2ab8a0905030922x722a45f3gf0790b5b90b0f2b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905031828.14468.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Francis,

(CC'ing netdev)

Le Sunday 03 May 2009 18:22:18 Francis Moreau, vous avez écrit :
> Hello,
>
> I got this since I updated my kernel from 2.6.29 to 2.6.30-rc4.
>
> Let me know if you need more information.

Is this seen on a Broadcom 47xx/53xx platform or on a computer with a PCI b44 
card ?

Thanks.
-- 
Best regards, Florian Fainelli
Email : florian@openwrt.org
http://openwrt.org
-------------------------------
