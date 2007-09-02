Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbXIBTFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbXIBTFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbXIBTFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:05:37 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44979 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbXIBTFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:05:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=b2njw6Fd2eICeY9WtyK4h+zXOJRTwwbpQWS9FN9hopwQa2LTxfINux5SWSG7MtyG8A9+XFbjD8sv37WFjeflDftwnUEjCcCTAQg1tWGY9uu+DCCA3MGtAekBvjPD2X1chyGM9hAnKx2uw7L0aoXI8bTB674FrFczcy5z02IedBU=
Message-ID: <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
Date: Sun, 2 Sep 2007 09:05:34 -1000
From: "charles gagalac" <charles.gagalac@gmail.com>
To: "daryll q" <daryll_26m@yahoo.com.ph>
Subject: Re: Hang in 2.6.23-rc5
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <994260.18490.qm@web57301.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/2/07, daryll q wrote:
> Upgraded my kernel from 2.6.23-rc2 to 2.6.23-rc5.
>
>  System hangs (caps lock and scroll lock leds are both
> flashing).
>
>  It *randomly* happens but most of the time during
> after login to KDE.
>
>  I have not investigated it yet because I have not
> tried doing it
>  before.
>
>  Also the system is really not responding so I can't
> do much.. Just
>  hope it blue screen so I can send the error code
> easily :)

i experienced hangs, with the flashing caps and scroll locks as you've
described, in a few of my later pulls prior to rc5.  i couldn't
reproduce the hangs and my logs didn't show evidence of a problem.  my
system under rc5, so far, hasn't hung on me.

charles
