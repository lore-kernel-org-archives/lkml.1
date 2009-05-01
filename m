Return-Path: <linux-kernel-owner+w=401wt.eu-S1757070AbZEAJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070AbZEAJkm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZEAJke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:40:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10187 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbZEAJkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PVaYIJdXk8Ro1jSbUvv5uEyeVa7ozcAQj/Dz8GKYslZWsU6rr0VXwPx+uV4b9FFjrS
         jUJMNi3ZhuZKVOrtTiG8N0T1IJuMkuH20REVCvGnpl8uDrWQesInJPNmqs/UhQbW4WXB
         N+lpqOgkndGP5Q/PgIapj6wH51aK8Yf4RAj+E=
MIME-Version: 1.0
In-Reply-To: <20090420122612.GB17483@game.jcrosoft.org>
References: <1227626565-25209-1-git-send-email-costa.antonior@gmail.com>
	 <20090420122612.GB17483@game.jcrosoft.org>
Date: Fri, 1 May 2009 11:40:32 +0200
Message-ID: <cd73a99e0905010240w3f5a87d4n40226f05e50faa55@mail.gmail.com>
Subject: Re: [PATCH 1/5] [RFC PATCH] Support for AT572D940HF-EK [RFC PATCH]
From: Andrew Victor <avictor.za@gmail.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: "Antonio R. Costa" <costa.antonior@gmail.com>, linux@maxim.org.za,
       nicolas.ferre@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Jean-Christophe,

>> AT572D940HF (Diopsis) is an ARM926 + a 40-bits floating point DSP
>> (mAgicV)
>>
> Any news?

I am busy merging the support for the AT572D940HF into my tree.
It will be included in the next AT91 patch, and thereafter submitted
to the mainline kernel.


Regards,
  Andrew Victor
