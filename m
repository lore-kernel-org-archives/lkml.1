Return-Path: <linux-kernel-owner+w=401wt.eu-S1423161AbXD3I50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423161AbXD3I50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423166AbXD3I5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:57:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:21334 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423161AbXD3I5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:57:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O0US4xoSorWLBufBJzNDo6qnnVSMA9XiaOMQboKORWhxaMyEjNEdjnum2JnkizIUBiCrjY9EGz2BD5xqyb9RZB2yumQpCecOkbeP8zSLbKylBP9pDwFQo6uWx4JVmmIXdhB68mZ565hNMulLtywKju4ri0ZWE5vYTd18TnA+P1U=
Message-ID: <6bffcb0e0704300157g5bd58565pd1f1a61d63296593@mail.gmail.com>
Date: Mon, 30 Apr 2007 10:57:20 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: tglx@linutronix.de
Subject: Re: Problem: 2.6.21 won't boot
Cc: "Riccardo Ricci" <rricci@nuovanetmore.it>, linux-kernel@vger.kernel.org
In-Reply-To: <1177765306.7646.152.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <55875.172.20.1.1.1177699628.squirrel@srv01.nuovanetmore.it>
	 <1177765306.7646.152.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Fri, 2007-04-27 at 20:47 +0200, Riccardo Ricci wrote:
> > Hi to everyone,
> > i've compiled kernel 2.6.21 on my debian PIII 650 / 256MB / Dell Latitude
> > J650GT. With 2.6.20.8 all works very good, with 2.6.21 don't boot... While
> > booting it stops after ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9
> > 10 11 12 14 15).
>
> Can you capture the 2.6.21 boot log via serial console ?

Or netconsole? Please read chapter 3
http://www.stardust.webpages.pl/files/handbook/handbook-en.pdf

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
