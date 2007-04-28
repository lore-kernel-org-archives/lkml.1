Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbXD1RSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbXD1RSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756502AbXD1RSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:18:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:27629 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbXD1RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gl8GfqoopCTv8Mt+RNaHZgt3Ia2ls0jGHmohO5s131xwKL7vA2Jp62aFqEVzJ2/bi+e/PAb0Ic+DWToPDOZWBltPHGBkHDLR9onbybxrG9fyzgS19Foe1elHuDVnvqvoD01cDtAI9UwAQ4JoLLLDOvlbhEGd/GmEn253xS5pkPQ=
Message-ID: <6bffcb0e0704281018h68a6d63fw8747b63bc1b86a4b@mail.gmail.com>
Date: Sat, 28 Apr 2007 19:18:20 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Gene Heskett" <gene.heskett@gmail.com>
Subject: Re: 2.6.21 known regressions (v2) (for -stable team)
Cc: stable@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, "Riccardo Ricci" <rricci@nuovanetmore.it>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       "Len Brown" <len.brown@intel.com>,
       "David Brownell" <david-b@pacbell.net>, "Jeff Mahoney" <jeffm@suse.com>,
       reiserfs-dev@namesys.com, "Jeff Chua" <jeff.chua.linux@gmail.com>,
       "Francois SIMOND" <curio@free.fr>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       netdev@vger.kernel.org,
       "=?ISO-8859-1?Q?H=E5kan_Lindqvist?=" <lindqvist@netstar.se>,
       "Vincent Frentzel" <zcecc22@ucl.ac.uk>,
       "=?ISO-8859-1?Q?Fran=E7ois_Valenduc?=" <francois.valenduc@skynet.be>,
       "Thomas Meyer" <thomas.mey@web.de>,
       "Giorgio Lando" <patroclo7@gmail.com>, "Dave Jones" <davej@redhat.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <200704281252.20381.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <463375E5.5040108@googlemail.com>
	 <200704281252.20381.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene,

On 28/04/07, Gene Heskett <gene.heskett@gmail.com> wrote:
> On Saturday 28 April 2007, Michal Piotrowski wrote:
> >Hi all,
> >
> >Here is a list of known regressions reported after 2.6.21 release.
> >
> >Feel free to add new regressions/remove fixed etc.
> >http://kernelnewbies.org/known_regressions
> >
> I went here, but without a login the page is immutable
>
> Therefore I'll add it here
>
> Subject         :proprietary belkin upsd turns into cpu hog

I'm not sure if I understand correctly. Is it a proprietary driver?
If so, it's not a task for -stable team.

> Submitter       :gene.heskett@gmail.com
> Reference       :something changed in how /dev/ttyUSB's handle 1 and 2 byte messages
> from pl2303 usb<->serial adaptors.  Also, assignation of ttyUSB#'s is
> volatile depending on phase of the moon when booted.

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
