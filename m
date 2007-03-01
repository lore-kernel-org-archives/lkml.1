Return-Path: <linux-kernel-owner+w=401wt.eu-S1030182AbXCAU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030182AbXCAU0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965565AbXCAU0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:26:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:41206 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965564AbXCAU0D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:26:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tHHrI5d/pRxP9uwxhkBXvUXP72OckOHSOWn9v2SWsv6KA8Tt9FR2sckkjOPfxOUAQtHGh+Q2uStZ5pJheY5G2voQrJxM3l3ZNQmGD40mCY+Pz3ZB7u6IRVGbYD3fDy67r4MTcevExGs438CIBT6fHAYzRHZSItHfj4EoC80NN30=
Message-ID: <d120d5000703011225t1ffaa33akbfcde29d2954601e@mail.gmail.com>
Date: Thu, 1 Mar 2007 15:25:41 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "=?ISO-8859-1?Q?Kristian_Gr=F8nfeldt_S=F8rensen?=" <kriller@vkr.dk>
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <1172779492.7396.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl>
	 <200703010036.28166.dtor@insightbb.com>
	 <1172779492.7396.2.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
>
> Hmmm.
>
> Now i get this BUG:
>

Does it die the same way if you just unload the button driver without
suspending?

-- 
Dmitry
