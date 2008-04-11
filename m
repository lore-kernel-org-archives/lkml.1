Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYDKQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYDKQHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbYDKQHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:07:07 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:59544 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532AbYDKQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LiL5jVgJUwrHRIhjuzKOZhXXc+s/PnZYETsjz0J2KgdxYhofsTCrrUv+neo0poCHUpmF03bSBuOxIJU8oidFh9f6kfiHgYtDkLihxsPqL9KULShNYCHJ9PYbsBAIVBRRZscTIeuIo3mZcwNIiMaPCNK7Gdlr+J/7H6IyEDfFaeM=
Message-ID: <dd18b0c30804110907k348f2a5cue4b59bd9d83cf7dc@mail.gmail.com>
Date: Fri, 11 Apr 2008 16:07:04 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: mutex_unlock
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20080411090729.GD10801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804090017m75c97f81qf6428b377432f8b5@mail.gmail.com>
	 <200804092240.26623.rjw@sisk.pl>
	 <dd18b0c30804091440x6e029daes8dd5f4dd848f5154@mail.gmail.com>
	 <20080411090729.GD10801@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 9:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Justin Mattock <justinmattock@gmail.com> wrote:
>
>  > >  > 2.6.25-rc8-00194-g4cac04d ran vary smoothly;
>  > >  > then I decided to pull the latest git (2.6.25-rc8-00208-g7180c4c)and
>  > >  > see what I might find.
>  > >  > upon reboot the system starts up giving me this:
>  > >  >
>  > >  > Starting up
>  > >  > Decompressing Linux Done
>  > >  > Booting the kernel
>  > >  > __   <-------blinking
>  > >  >
>  > >  > I waited a few seconds or minutes but nothing;
>
>  to perhaps get more kernel messages about this, try the earlyprintk=vga
>  boot option - does it produce any messages?
>
>         Ingo
>

Thanks for the info, I can try that and see if I receive any kind of messages.
regards;

-- 
Justin P. Mattock
