Return-Path: <linux-kernel-owner+w=401wt.eu-S1759761AbXFRGld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759761AbXFRGld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 02:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbXFRGlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 02:41:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:6430 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbXFRGlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 02:41:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cgIiig3h0MgpJqeF+6S/swWxn9gQsqv4+t7dzszk+QR9/mcPQW0dVAxRZwCw6j56izXCVYVkwnzXLFE0GS5QoB7KpO44Z9w+Ae1x3979hHCsfISNrdcPRH0v5qrBNTPF0zbcarLh5I+NW609B8vn6ehaBDuMQkMBf+OMrjhvMig=
Message-ID: <a8e1da0706172341j3ee621efs8b2809b4fd094004@mail.gmail.com>
Date: Mon, 18 Jun 2007 06:41:23 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH] cdrom_sysctl_info fix
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070618062722.GP6149@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com>
	 <20070615132657.GW6149@kernel.dk>
	 <20070618125811.GA1692@darkstar.te-china.tietoenator.com>
	 <20070618062722.GP6149@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> Yep that looks much better! I trust you booted and tested this and the
> output looks correct?
Yes, I tested and the output is correct.

BTW, another problem, I can't find the CONFIG_CDROM option in kernel
config menu. Is it deperacated? If it is true, is the module part
still necessary?

Regards
dave
