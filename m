Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbXH3K0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbXH3K0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 06:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755061AbXH3K0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 06:26:24 -0400
Received: from web32613.mail.mud.yahoo.com ([68.142.207.240]:25571 "HELO
	web32613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754412AbXH3K0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 06:26:23 -0400
X-YMail-OSG: SmRuHRYVM1m455SI5JujG.xltSROL3NAaFbs3kd2wfoVCzDR9mf.DL4yVZ7pFKzvlYXvbHzXDO7jidBoHMDh2G6_yg--
X-RocketYMMF: knobi.rm
Date: Thu, 30 Aug 2007 03:26:22 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: spamtrap@knobisoft.de
Subject: Re: Understanding I/O behaviour - next try
To: Robert Hancock <hancockr@shaw.ca>, Jens Axboe <jens.axboe@oracle.com>
Cc: Martin Knoblauch <spamtrap@knobisoft.de>, linux-kernel@vger.kernel.org,
       Peter zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com
In-Reply-To: <46D58264.6050403@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <504223.55411.qm@web32613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Robert Hancock <hancockr@shaw.ca> wrote:

> 
> I saw a bulletin from HP recently that sugggested disabling the 
> write-back cache on some Smart Array controllers as a workaround
> because 
> it reduced performance in applications that did large bulk writes. 
> Presumably they are planning on releasing some updated firmware that 
> fixes this eventually..
> 
> -- 
> Robert Hancock      Saskatoon, SK, Canada
> To email, remove "nospam" from hancockr@nospamshaw.ca
> Home Page: http://www.roberthancock.com/
> 
Robert,

 just checked it out. At least with the "6i", you do not want to
disable the WBC :-) Performance really goes down the toilet for all
cases.

 Do you still have a pointer to that bulletin?

Cheers
Martin

------------------------------------------------------
Martin Knoblauch
email: k n o b i AT knobisoft DOT de
www:   http://www.knobisoft.de
