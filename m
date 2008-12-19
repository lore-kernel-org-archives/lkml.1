Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYLSUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYLSUlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 15:41:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYLSUlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 15:41:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:40832 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYLSUlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 15:41:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Um9nRgQ8qz/ezEoRKo6GLt5ZFM5I90jfRCNsSKGXwZxmMKa1pawtsmHg36i8Z84ptH
         5OYodUFj7UGsc9uoPHSSf1Js1MzUFGU0k+PJJrZ/Ce3v0bL9gc3V5SiHCoRKYnEzAJs2
         A4H+gmA4wCpvLGmxwCuUX1yMwpKw8Jvp3wBvo=
Message-ID: <3f9a31f40812191241q40dafdb0lfd2f4487f2870e2@mail.gmail.com>
Date: Sat, 20 Dec 2008 02:11:04 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: Firmware patches for SCSI
Cc: linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <1229718543.18778.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40812191153n636888f4i549409453266d58c@mail.gmail.com>
	 <1229718543.18778.4.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello James,

On Sat, Dec 20, 2008 at 1:59 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> Um ... depends how they got into linux-next.  The head commit just says
>

They got into linux-next via David Woodhouse. :
http://git.infradead.org/users/dwmw2/firmware-2.6.git

> Merge commit 'firmware/master'
>
> Which isn't very descriptive of where it came from.  It looks like
> either a tree that linux-next shouldn't pull (or one the owner forgot to
> push to linus).
>

Earlier due to Firmware issues firmware patches are going directly
though David Woodhouse.

Now firmware issues are solved so David wants that the _driver_
patches should be sent directly to the appropriate maintainers / mailing lists.

So I am curious that should I resend these patches based on which git tree.

Thank you,

Jaswinder Singh.
