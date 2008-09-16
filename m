Return-Path: <linux-kernel-owner+w=401wt.eu-S1756155AbYIPPZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbYIPPZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 11:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbYIPPZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 11:25:25 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:37767 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233AbYIPPZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 11:25:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Dklp22dgLvq77vLRh6ttrjy0TA4b25RxsLpx8HvzhArNirlfNhvIlOY2apSOvBhrGg
         dNbSWl7/hQtfQGOQ86ELvbE4qZ8kEv/41EqCcv36girRgm5yX2fY2KxjSanyFuy3cvQ0
         IATsxQADwDajs8u3EQz3GMXoaNokZwlxs5aI8=
Message-ID: <3f9a31f40809160825s4bd0f950td2b29107113e79e0@mail.gmail.com>
Date: Tue, 16 Sep 2008 20:55:22 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #11272] BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       linux-serial@vger.kernel.org
In-Reply-To: <SpS7rta8n4.A.17.FfsyIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.17.FfsyIB@albercik>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am sorry for delay.

On Sat, Sep 13, 2008 at 12:36 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=11272
> Subject         : BUG: parport_serial in 2.6.27-rc1 for NetMos Technology PCI 9835
> Submitter       : Jaswinder Singh <jaswinderlinux@gmail.com>
> Date            : 2008-08-05 15:12 (39 days old)
> References      : http://marc.info/?l=linux-kernel&m=121794900319776&w=4
>

I have tested parport_pc and also tried with pcmcia_cs, only thing I
get is disappointment. So I give up :-(

Now I switched to usbserial.
usbserial drivers are working great !!

Now I do not want to use parport_pc and pcmcia_cs atleast for 2 years,
I hope in 2 years this will be solved ;)

In the mean time, If you think my problem is solved just ping to me I
will test and let you know the results.

Thank you for all your support and help.

Jaswinder Singh.
