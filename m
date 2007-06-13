Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbXFMBhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbXFMBhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 21:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXFMBhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 21:37:07 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42101 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbXFMBhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 21:37:04 -0400
Message-ID: <466F4A27.8070309@tw.ibm.com>
Date: Wed, 13 Jun 2007 09:36:39 +0800
From: Albert Lee <albertcc@tw.ibm.com>
Reply-To: albertl@mail.com
User-Agent: Mozilla Thunderbird 1.0.6 (Windows/20050716)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Mark Lord <mlord@pobox.com>, Robert de Rooy <robert.de.rooy@gmail.com>,
       Mark Lord <liml@rtr.ca>, Jeff Garzik <jeff@garzik.org>,
       bzolnier@gmail.com, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: libata and legacy ide pcmcia failure
References: <466718B6.4080105@gmail.com> <4667B39D.209@gmail.com> <46685AE5.4010908@gmail.com> <466900F3.7040801@gmail.com> <46694FB2.6040007@pobox.com> <4669D2D8.3020806@gmail.com> <4669D3F5.7040300@rtr.ca> <466B4D86.1020808@gmail.com> <466C631D.2000001@rtr.ca> <466C723C.6000300@gmail.com> <20070610221322.GA18196@flint.arm.linux.org.uk> <466C7A9F.1080700@rtr.ca> <466DCE55.30507@gmail.com> <466DCF43.5060304@pobox.com> <466E11DF.5020901@gmail.com>
In-Reply-To: <466E11DF.5020901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> libata can do most of this too by using ATA_FLAG_PIO_POLLING (doesn't
> cover nodata commands tho).
> 

Hi Tejun,

Polling of nodata commands was fixed in:
http://marc.info/?l=linux-ide&m=116546272916399&w=2

--
albert

