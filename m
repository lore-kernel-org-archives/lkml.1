Return-Path: <linux-kernel-owner+w=401wt.eu-S1161125AbXDEDz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161125AbXDEDz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 23:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161121AbXDEDz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 23:55:26 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:41872 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161125AbXDEDzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 23:55:25 -0400
X-IronPort-AV: i="4.14,373,1170651600"; 
   d="scan'208"; a="26394352:sNHT26538246"
Subject: Re: [PATCH] Blackfin arch: sync with uClibc no functional changes
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Mike Frysinger <vapier.adi@gmail.com>
In-Reply-To: <1175668055.10608.35.camel@roc-desktop>
References: <1175668055.10608.35.camel@roc-desktop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Thu, 05 Apr 2007 11:57:07 +0800
Message-Id: <1175745427.17315.22.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +.text
> +
> +.align 2
> +
>  ENTRY(_memchr)
> -	P0 = R0 ;             /* P0 = address */
> -	P2 = R2 ;             /* P2 = count */
> +	P0 = R0;             // P0 = address
> +	P2 = R2;             // P2 = count

Sorry for introducing wrong coding style source.
A updated one will be posted later.

Thanks Robin and Mike.
-Bryan
