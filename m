Return-Path: <linux-kernel-owner+w=401wt.eu-S932424AbYEGWn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424AbYEGWn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:43:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757398AbYEGWng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:43:36 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:54177 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032AbYEGWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:43:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L0eCRCnwLiym+r8x0Jqv+IvngN/gKdsjjy8LQIEMVangUaYEWqcOBJLxZ5HoY8E5Zch3/X+6KvWsdeGre1OBL8jqwb5KRRmNZv2+8AjM1NVTBHaVGo5Q6Zqbc6PVU70x82OoVnVcInRs2fmZ6TTXj212U7eIWBtbCGiYcCP01AI=
Message-ID: <dd18b0c30805071543u5cf7915av162fa6e23ab0deda@mail.gmail.com>
Date: Wed, 7 May 2008 22:43:28 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "James Cloos" <cloos@jhcloos.com>
Subject: Re: Regression: starting X locks box with git master
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Yinghai Lu" <yhlu.kernel@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m3ej8dbwfp.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m3hcdrqb03.fsf@lugabout.jhcloos.org>
	 <86802c440804241352v2623222bt28129a2c501cff25@mail.gmail.com>
	 <m37iemq3qa.fsf@lugabout.jhcloos.org> <200805072353.02085.rjw@sisk.pl>
	 <m3ej8dbwfp.fsf@lugabout.jhcloos.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 10:06 PM, James Cloos <cloos@jhcloos.com> wrote:
> >>>>> "Rafael" == Rafael J Wysocki <rjw@sisk.pl> writes:
>
>  >> But the kernel which dies does generate this:
>
>  >> Apr 24 04:28:09 [kernel] [    0.000000] x86: PAT support disabled.
>
>  Rafael> Has the problem been fixed in 2.6.26-rc1 or in the current -git?
>
>  I plan on giving current master a test tonight.
>
>  -JimC
>  --
>  James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
>

Cool;
>From what I've experienced out of 2.6.25-rc* to the latest git  with a
macbook pro; 2.6.25-rc7,8,or 9 runs the best i.g.
not as hot, fans don't trip as often, when listening to music, and
then compiling you don't have a skip., suspend works
lircd works, isight works.  As for 2.6.26-rc1 lircd doesnt work for
some reason, isight now works, atheros now works, fglrx does'nt due to
something deep into the kernel was changed(who knows what that might be)
did find the kernel running kind of quieter  but noticed the fans
would rev up every so often (estimation would be around 35 min to 60
min + or - )
probably a new mechanism to cool things down. Sound is working, but
every so often a song sounds as if you have blown out speakers.
I probably will pull the latest git, but after spending countless
hours, trying to get fglrx up and running,  and realizing something
was drastically changed in that area, I've decided to go get some
liquid propulsion and call it a day.
regards;

-- 
Justin P. Mattock
