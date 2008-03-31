Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbYCaKpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbYCaKpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 06:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYCaKph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 06:45:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:17373 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830AbYCaKpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 06:45:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KLAjpxh0Sm0+2IVI1tcvj11/uN5WTPXJNZ9LWZqrrWi/cxZsTvqbDv1sM4PvRh9p/ularH1pN80H0g7lgMO7AYEfV6Z6ce+Aw8VUzTKvZyCYI5zVRzcoFVTeA3DD8rP17KRLPNzhBpU4WTuBV3V1COV+PBISE6Imwoqc4u7ePlk=
Message-ID: <5699f8f00803310345i30e64e95m6543b5ec99243a7f@mail.gmail.com>
Date: Mon, 31 Mar 2008 11:45:35 +0100
From: "Wander Winkelhorst" <w.winkelhorst@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: RFC: Writing Solaris Device Drivers in Java
Cc: "Peter Teoh" <htmldeveloper@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>
In-Reply-To: <1206959293.8514.636.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47F0491F.4050804@gmail.com> <1206959293.8514.636.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 11:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2008-03-31 at 10:14 +0800, Peter Teoh wrote:
>
> > Interesting read:
>  >
>  > http://research.sun.com/techrep/2006/smli_tr-2006-156.pdf
>  >
>  > Personal comments:
>  >
>  > Since KVM and Xen/OpenVZ etc other virtual machines are beginning to pop
>  > up - I don't see why it inhibits (in spite of the many initial
>  > difficulties as mentioned in the paper) the growth of using Java for
>  > device drivers development.   Contrast it against udev - esp in terms of
>  > usability/supportability/extensibility etc.   udev is a Linux thing,
>  > whereas Java is at industry level.   If everyone write applications
>  > device drivers using Java (minus the extreme hardware arch specific
>  > stuff, but supports all the low level protocol specific stuff like
>  > TCP/IP, NFS, USB etc) then I think it has potential to compete against C
>  > lang - the monopolizer till today in the kernel world
>  > (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for
>  > the Solaris in Linux, won't it be cool?
>
>
>  LOL.. good joke!
>
>  But as others have pointed out, you missed April's fools by 1 day.

It is actually 1st of april in Kiritimati for about 45 minutes at the
time of this writing.
http://www.timeanddate.com/worldclock/city.html?n=274
