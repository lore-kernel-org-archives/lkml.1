Return-Path: <linux-kernel-owner+w=401wt.eu-S933755AbXK2UG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755AbXK2UG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbXK2UGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:06:16 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:41425 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759521AbXK2UGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:06:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cYmFsZM1iwLQR00hv8ydl1oh8yuVwxSdU9OMvuf30/2od11q5yTAgsQblTMaRPPYAd2AWkzzQbZYl8bBjB+ELJ3WljJXi335pckwOM5yY3GffrXijtzl6pFeQpQvS14PIVBx2eOUa/+WpchwpNnn1cAiw/6mdGcgx9iZtXDvCkY=
Message-ID: <5a4c581d0711291206x5d92c166iba4e4b6d336643dc@mail.gmail.com>
Date: Thu, 29 Nov 2007 21:06:12 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: ata4294967295: failed to start port (errno=-19)
Cc: "Meelis Roos" <mroos@linux.ee>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071128200716.14eccfdd@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee>
	 <20071128200716.14eccfdd@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 28, 2007 9:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > This message comes from 2.6.24-rc3 + todays git, version
> > a531a141089714efe39eca89593524fdf05104f2. I did grep the logs and found
> > that it first appeared in 2.6.24-rc1 (+ some git mayve) on Nov 3.
> > I used 2.6.23 before that and it did not show this message.
>
> Can you stick a stack trace in at that point ? That would help diagnose
> it a great deal quicker.

I've also been seeing this for a while on my Dell Latitude D610,
 but stuff just works, so... I'm overloaded at this time, if nobody
 gets there first I'll give a go at tracing this next week.

--alessandro

 "Damaged people are dangerous. They know they can survive."

   (Anna Barton/Juliette Binoche, 'Damage')
