Return-Path: <linux-kernel-owner+w=401wt.eu-S1764421AbXF1Psl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764421AbXF1Psl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757383AbXF1Psc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:48:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:21036 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbXF1Psb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ADWggrGgmo89IqitvJmGnjO46oo3DwDnfJfZGJaUxfnPn/RtfXpRCBDt65mj1T8QG+VGrHraDW3m64HXQwtm811kWreele4PRlQ36E+SmCulMJuPte2ealTbwgkuv9kECRBOHaD+6RYOWgCD0eJvxdBNZN7KP9CspLVNVehRcDU=
Message-ID: <81b0412b0706280848o790394f6l65e16891e400dfc9@mail.gmail.com>
Date: Thu, 28 Jun 2007 17:48:29 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>
Subject: Re: New format Intel microcode...
Cc: "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Daniel J Blueman" <daniel.blueman@gmail.com>,
       "Shaohua Li" <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <1183039975.14676.12.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com>
	 <1174610594.6598.3.camel@sli10-conroe.sh.intel.com>
	 <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com>
	 <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com>
	 <1183039975.14676.12.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By any chance, do you known anything about microcode driver which
uses standard firmware load interfaces (like those used by wlan card)?
In particular, what format does the driver expect the microcode in?
It didn't accept Tigran's files in past, does it accept them now?
