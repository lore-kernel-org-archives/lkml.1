Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbXFMUu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbXFMUu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbXFMUut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:50:49 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:48726 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbXFMUus convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:50:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=t/IAX0S4t1AMJYwpnk3P9XgJ5YeK9fCxdf3p8MnWlQ7udpAOzQsLWDgGJklh69ZNIjMisxxvNl4BbIOxTH835wPJZbNUJ5DCDm6/ztU0OU+BApOQibbVxZojV85fHeKaA6bGQK+cABdEZXqIlKdl5o76kXyyXxhghjITHgTwMCc=
Message-ID: <6bffcb0e0706131350p4a267fb9ycbc59059956ba896@mail.gmail.com>
Date: Wed, 13 Jun 2007 22:50:43 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       "Dan Aloni" <da-x@monatomic.org>,
       "Chad Tindel" <ctindel@users.sourceforge.net>,
       "Jay Vosburgh" <fubar@us.ibm.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       sparclinux@vger.kernel.org, "David Miller" <davem@davemloft.net>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Pavel Machek" <pavel@ucw.cz>, linux-usb-devel@lists.sourceforge.net,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Alex Riesen" <raa.lkml@gmail.com>, "Andi Kleen" <ak@suse.de>,
       discuss@x86-64.org, "Ioan Ionita" <opslynx@gmail.com>
Subject: Re: [2/2] 2.6.22-rc4: known regressions v3
In-Reply-To: <20070613202155.GA11073@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46704923.1010009@googlemail.com> <46704C44.8020602@googlemail.com>
	 <20070613202155.GA11073@atjola.homenet>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/06/07, Björn Steinbrink <B.Steinbrink@gmx.de> wrote:
> On 2007.06.13 21:57:56 +0200, Michal Piotrowski wrote:
> > TTY
> >
> > Subject    : OOPS (NULL pointer dereference) in v2.6.22-rc3
> > References : http://lkml.org/lkml/2007/6/1/389
> >             http://bugzilla.kernel.org/show_bug.cgi?id=8473
> >             http://bugzilla.kernel.org/show_bug.cgi?id=8574
> > Submitter  : Alex Riesen <raa.lkml@gmail.com>
> > Status     : problem is being debugged
>
> Patch available at: http://lkml.org/lkml/2007/6/8/490

Thanks for letting me know.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
