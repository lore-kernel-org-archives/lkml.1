Return-Path: <linux-kernel-owner+w=401wt.eu-S935376AbXLNA4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376AbXLNA4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXLNAzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:55:53 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:2960 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbXLNAzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:55:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ycu0IzKSLgV55jyHlo416W/tlhyZy14v9o1ykP2ay1yznRvgCxxcZtq7wsMSbE43ys5SIfBTRN6Be/BIuqFujDuPILoKs9A2WbaKFZ9YQTBZC8+j5oazlVsHADvbphMuqZkMVSD7VNFbFqnjt4iMy6gAz7c5ZRfBW9UZW4+/Dvw=
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore
	to mutex
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, bcm43xx-dev@lists.berlios.de,
       Daniel Walker <dwalker@mvista.com>, akpm@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, linux@bohmer.net,
       jonathan@jonmasters.org, matthias.kaehlcke@gmail.com,
       kjwinchester@gmail.com, mbuesch@freenet.de,
       John Linville <linville@tuxdriver.com>
In-Reply-To: <200712140143.16451.mb@bu3sch.de>
References: <20071213003028.676998182@mvista.com>
	 <200712131445.39770.mb@bu3sch.de>
	 <2c0942db0712131604m41c34da9hf3122b0603f3af96@mail.gmail.com>
	 <200712140143.16451.mb@bu3sch.de>
Content-Type: text/plain
Date: Thu, 13 Dec 2007 16:55:50 -0800
Message-Id: <1197593750.898.34.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-14 at 01:43 +0100, Michael Buesch wrote:
> Oh come on. b43 is more than a year old now. How long should we wait?
> Two or three? Forever?
> 

Any pointers to the advantages of b43?

Harvey

