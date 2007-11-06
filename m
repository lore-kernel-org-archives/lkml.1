Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbXKFFIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbXKFFIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 00:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757493AbXKFFIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 00:08:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:48820 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbXKFFIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 00:08:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UPowbspOnC/8BVdzjtWVBPe20DcFRgAN60w1wrmXH6xqDmZYup74M+l4pHr5HC0/3rgMwfSeHxjce+AYenCh3e0VNFSNOG7LQxj1NmKA3SjGlNJ229r1iDfUp76ve6S5U4KqngW0VPD6cF4pEqRJ2sxiy/CbPGERKvmIt+q0AMw=
Message-ID: <8bd0f97a0711052108i279f9325qbc9e039303633e98@mail.gmail.com>
Date: Tue, 6 Nov 2007 00:08:03 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: a list of non-existent but included include/linux header files
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711052355490.21645@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0711052327090.6602@localhost.localdomain>
	 <8bd0f97a0711052051v45856f6apfacd66ade1d47113@mail.gmail.com>
	 <Pine.LNX.4.64.0711052355490.21645@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> arch/blackfin/mm/blackfin_sram.c:#include <linux/autoconf.h>
> arch/blackfin/mach-common/interrupt.S:#include <linux/autoconf.h>

i seem to recall these already getting fixed, but just in case, ive
queued up patches for these

cheers
-mike
