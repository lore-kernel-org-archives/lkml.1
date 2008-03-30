Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYC3Jat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYC3Jat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 05:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751274AbYC3Jaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 05:30:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:59509 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbYC3Jah convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 05:30:37 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: [Bug 10345] USB HID problems after resume
Date: Sun, 30 Mar 2008 10:30:46 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bugme-daemon@bugzilla.kernel.org, rjw@sisk.pl, bunk@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <20080328223544.A61F711D10C@picon.linux-foundation.org> <47EE78C9.5090006@rtr.ca> <47EE793C.5070105@rtr.ca>
In-Reply-To: <47EE793C.5070105@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803301130.47607.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 29. März 2008 18:15:40 schrieb Mark Lord:
> bugme-daemon@bugzilla.kernel.org wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=10345
> >
> >
> > rjw@sisk.pl changed:
> >
> >            What    |Removed                     |Added
> > ----------------------------------------------------------------------------
> >              Status|NEW                         |REJECTED
> >          Resolution|                            |UNREPRODUCIBLE
> >
> >
> >
> >
> > ------- Comment #2 from rjw@sisk.pl  2008-03-28 15:35 -------
> > Handled-By : Mark Lord <lkml@rtr.ca>
> > References : http://lkml.org/lkml/2008/3/28/346
> >
> > Mark said:
> >
> > "Also, for now it seems to be "resolved" via a seemingly-unrelated
> > change in the .config file on that machine.  If it dies again,
> > I'll re-post and investigate further."
> ..
> 
> Just happened again.  The machine resumed from RAM with no functioning USB.
> Still running the exact same 2.6.25-rc7 kernel as before, with the RTC conflict fixed.
> 
> WTF?

Is khubd stuck in D state?

	Regards
		Oliver
