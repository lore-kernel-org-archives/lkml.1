Return-Path: <linux-kernel-owner+w=401wt.eu-S933657AbZIDKWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657AbZIDKWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 06:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933437AbZIDKWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 06:22:08 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35572 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbZIDKWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 06:22:07 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Greg KH <greg@kroah.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
Date: Fri, 4 Sep 2009 12:23:22 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com> <200909030907.02321.oliver@neukum.org> <20090903160536.GA24050@kroah.com>
In-Reply-To: <20090903160536.GA24050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909041223.22835.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. September 2009 18:05:36 schrieb Greg KH:
> On Thu, Sep 03, 2009 at 09:07:01AM +0200, Oliver Neukum wrote:
> > Am Mittwoch, 2. September 2009 16:15:28 schrieb Maciej Rutecki:
> > > KERNEL[1251900287.925994] remove
> > > /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
> > > KERNEL[1251900287.926058] remove
> > > /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
> >
> > You are definitely seeing the correct kernel events.
> > So it must be an indirect problem.
> >
> > Greg, any changes in sysfs between rc7 and rc8?
>
> No, not that I sent in.

Maciej,

can you run a git bisection?

	Regards
		Oliver

