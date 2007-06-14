Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbXFNJjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbXFNJjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbXFNJjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:39:43 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:15584 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbXFNJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mQ4JgXQIbzkt+CvNAwEGMRwsm/eh0aOj/8CGXr/rjTJAPD7naL6OWCa7txaHiYhi8pf35jqh0U4+yj6ho+soX8hSqGzZ0AuvVvviAt66m2XxZ9AWWYstCfLiXheW2GlvbKP8blnBOSuuBPftDp0/NtYzSdDnvrLCW/xASondU00=
Message-ID: <46710CD7.9070901@gmail.com>
Date: Thu, 14 Jun 2007 18:39:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: albertl@mail.com
CC: Mark Lord <mlord@pobox.com>, Robert de Rooy <robert.de.rooy@gmail.com>,
       Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       bzolnier@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com> <466F4A27.8070309@tw.ibm.com>
In-Reply-To: <466F4A27.8070309@tw.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Lee wrote:
>>
>> libata can do most of this too by using ATA_FLAG_PIO_POLLING (doesn't
>> cover nodata commands tho).
>>
> 
> Hi Tejun,
> 
> Polling of nodata commands was fixed in:
> http://marc.info/?l=linux-ide&m=116546272916399&w=2

Right.  Thanks for reminding me.  :-)

-- 
tejun
