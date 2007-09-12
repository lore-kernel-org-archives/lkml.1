Return-Path: <linux-kernel-owner+w=401wt.eu-S969259AbXILRZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969259AbXILRZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 13:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764843AbXILRY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 13:24:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:39261 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbXILRY4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 13:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bhOto9KyJZZD2tc3qmNu7VcDdg8Kp7ycs8lVrzw9uTfo0CKouwXTRMU7mzEuUlK5un03UtYnMpRWXyDoeT+zr+DqMYiq+63vGwUNMWzq1ivJ/M6lzbKlgEjPUG6YLlsGL3ZN8BYLcaUTINkUCJNG+NG7j5fPcbaOhJNtQc8EQxw=
Message-ID: <6bffcb0e0709121024h6b07c4dfl62531c616490082b@mail.gmail.com>
Date: Wed, 12 Sep 2007 19:24:53 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: 2.6.23-rc6: known regressions with patches
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Vitaly Bordug" <vitb@kernel.crashing.org>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Greg KH" <gregkh@suse.de>, "Anssi Hannula" <anssi.hannula@gmail.com>,
       "=?ISO-8859-1?Q?Toralf_F=F6rster?=" <toralf.foerster@gmx.de>,
       netdev@vger.kernel.org, "Christian Kujau" <lists@nerdbynature.de>,
       jamal <hadi@cyberus.ca>, linux-usb-devel@lists.sourceforge.net,
       sean@mess.org, "Adrian Bunk" <bunk@kernel.org>
In-Reply-To: <1189616905.3570.59.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46E81AE2.8030802@googlemail.com>
	 <1189616905.3570.59.camel@shinybook.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2007, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2007-09-12 at 18:59 +0200, Michal Piotrowski wrote:
> > MTD
> >
> > Subject         : include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
> > References      : http://lkml.org/lkml/2007/9/11/151
> > Last known good : ?
> > Submitter       : Toralf Förster <toralf.foerster@gmx.de>
> > Caused-By       : ?
> > Handled-By      : ?
> > Patch           : http://git.infradead.org/?p=mtd-2.6.git;a=commit;h=241651d04d672fb685b2874707016cbbf95931e5
> > Status          : patch available
>
> Didn't you already _drop_ this from your list of regressions once?

Yeah :)

removed.

>
> --
> dwmw2
>
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
