Return-Path: <linux-kernel-owner+w=401wt.eu-S1759715AbXKQM1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715AbXKQM1U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 07:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXKQM1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 07:27:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbXKQM1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 07:27:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Will Trives <will@trivescon.com.au>
Subject: Re: 2.6.24-rc2-git6: Reported regressions from 2.6.23
Date: Sat, 17 Nov 2007 13:44:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Tejun Heo <htejun@gmail.com>, linux-kernel@vger.kernel.org
References: <1195296974.5149.11.camel@Athas>
In-Reply-To: <1195296974.5149.11.camel@Athas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711171344.19402.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 of November 2007, Will Trives wrote:
> > Subject    :  cd/dvd inaccessible in 2.6.24-rc2 
> > Submitter  :  Will Trives <will@trivescon.com.au> 
> > References :  http://lkml.org/lkml/2007/11/9/290 
> >               http://bugzilla.kernel.org/show_bug.cgi?id=9346 
> > Handled-By :  Alan Cox <alan@lxorguk.ukuu.org.uk> 
> >               Jeff Garzik <jeff@garzik.org>
> 
> > Not being handled by any more. 2.6.24-rc2 shows assorted IRQ delivery
> > and IRQ assignment problems for IDE controllers which appear to be
> > ACPI problems. Its one for the ACPI people to take a look at.
> > 
> 
> I was wrong originally, the issue is acctually occuring whenever I try
> to write to a cd. With wodim or k3b, I am unable to write to the drive.
> The error shown in dmesg is what happened when I tried to blank a disc.
> In 2.6.23 it works instantly, with 2.6.24-rc4 it sits there, then there
> are those errors, then I cannot eject the dvd from the drive. With k3b
> it takes an age just to load and when it does it reports no media in the
> drive, I am also unable to eject the media from the drive.
> 
> I can mount a standard dvd without issue in 2.6.24-rc3. It's just
> writing that fails.

Please add this information to the bug entry at
http://bugzilla.kernel.org/show_bug.cgi?id=9346 

Thanks,
Rafael
