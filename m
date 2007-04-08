Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXDHN0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXDHN0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 09:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXDHN0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 09:26:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:31491 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXDHN0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 09:26:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ldkaSk7u9d9QvxHVmxoCokKaKfpoynEahD7CA291tKaZ1nwfOjPXHlA/81Vz66KY0aR0Bro1ReNvAdT4dhHiwWTmxzsqk1Y4iKu47mp08QRZBFmIihpXB/TsmdEsWU5+UldM2Xb0RYvP71R1XmJTKhtSNbb9gWf3f+LQK3G7xO0=
Message-ID: <6bffcb0e0704080626nfb89c3cif9fd572a4ac58a30@mail.gmail.com>
Date: Sun, 8 Apr 2007 15:26:31 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: mm snapshot broken-out-2007-04-07-03-27.tar.gz uploaded
Cc: "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200704071029.l37ATdKR032505@shell0.pdx.osdl.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> The mm snapshot broken-out-2007-04-07-03-27.tar.gz has been uploaded to
>
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-07-03-27.tar.gz
>

Thomas,

I get a lot of "NOHZ: local_softirq_pending 0a" messages, when I run
netperf2 test.

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-config
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/broken-out-2007-04-07-03-27/mm-dmesg2

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
