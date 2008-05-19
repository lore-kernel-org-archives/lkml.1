Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbYESGjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbYESGjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 02:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYESGjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 02:39:13 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:6135 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYESGjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 02:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=p7JXerZNzL4jRU46LSRKWVWIkSOB3+qPIJdCwEJZR2GVj4ZOoAeIopKMowTwipDI9zgnciBP2CBEZ9AdQbB8c+POiVA7ihkR49BAius6Szb2CapaBmHvxZqLHY9whIYd8x/SLgJ8sp6ItZVfIW+bEkS8mh87jhqVV+0HfH6xoZ4=
Message-ID: <386072610805182339n2e141b83q4b8f9804194088e4@mail.gmail.com>
Date: Mon, 19 May 2008 14:39:10 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Cc: me@felipebalbi.com, tony@atomide.com, linux-omap@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805170737.37806.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
	 <200805170737.37806.david-b@pacbell.net>
X-Google-Sender-Auth: 2abe9669afe273b9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 17, 2008 at 10:37 PM, David Brownell <david-b@pacbell.net> wrote:
> On Saturday 17 May 2008, Bryan Wu wrote:
>>
>> We discussed these 4 bugs before. Now we fixed them.
>> Please review following 2 patches.
>
> They looked plausible to me ... though the urb->status
> one is a bit of a band-aid, and when that field finally
> vanishes a better fix will be needed.
>

OK, so is there any plan for merge the MUSB to mainline and finally to
remove the urb->status?

-Bryan
