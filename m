Return-Path: <linux-kernel-owner+w=401wt.eu-S966759AbXEGUj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966759AbXEGUj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 16:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966522AbXEGUjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 16:39:54 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:34397 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966747AbXEGUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 16:39:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jLFoYL8lfN2lNCAHga/LuJNFvZjwHGegNwqata9hPKLTqR8csrRz40jhWY1hu7tMgP7v1NuJ2V+bAfyA96r1DsajCsoEaAveJX04yEAd1pIIFQstzj7o31TIKATFYa4gaVQKUH17OvJayGuKbM4H7i8gmPrdX9EHX3Cr0N+c5eI=
Message-ID: <c384c5ea0705071339u312f421bm539ae539530e28f4@mail.gmail.com>
Date: Mon, 7 May 2007 22:39:52 +0200
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Intel IXP4xx network drivers
Cc: "Jeff Garzik" <jeff@garzik.org>, "Russell King" <rmk@arm.linux.org.uk>,
       lnetdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
In-Reply-To: <m3abwhcy74.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3abwhcy74.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

...
drivers/net/ixp4xx/ixp4xx_eth.c
drivers/net/ixp4xx/ixp4xx_npe.c
drivers/net/ixp4xx/ixp4xx_qmgr.c
...

suggestion: credit Christian for his work by putting his copyright in
the header as well?

Thanks to both of you!

Leon.
