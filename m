Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826Ab0ANGFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab0ANGFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655Ab0ANGFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:05:37 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:46592 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0ANGFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:05:36 -0500
Date: Thu, 14 Jan 2010 07:05:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk
Subject: Re: Changelog quality
In-Reply-To: <4B4EAA73.5060103@freemail.hu>
Message-ID: <Pine.LNX.4.64.1001140704410.18724@ask.diku.dk>
References: <20100113174446.GA20754@kroah.com>
 <Pine.LNX.4.44L0.1001131301180.3518-100000@iolanthe.rowland.org>
 <20100113195226.GD8438@kroah.com> <4B4EAA73.5060103@freemail.hu>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-20773290-1263449132=:18724"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-20773290-1263449132=:18724
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 14 Jan 2010, Németh Márton wrote:

> Greg KH wrote:
> > On Wed, Jan 13, 2010 at 01:04:52PM -0500, Alan Stern wrote:
> >> On Wed, 13 Jan 2010, Greg KH wrote:
> >>
> >>>> It would be nice if there was a way to link automatically a git commit
> >>>> to an archived copy of the email message in which it was originally 
> >>>> submitted.
> >>> Ingo has been doing this on some patches by putting a message-id field
> >>> in the signed-off-by area showing what lkml message a patch came from.
> >>>
> >>> See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
> >>> tree as an example of this.
> >>>
> >>> I have no objection if people want to do this for any patches going
> >>> through my tree as well.
> >> If it has to be included manually by the patch submitter then it isn't
> >> automatic.  Not to mention that the submitter would need to know the
> >> email's message-id before the email message was sent!
> >>
> >> Something like this should belong in a maintainer's script.
> > 
> > Yeah, that would get messy, as usually a patch happens in a different
> > thread than the original problem occurs, so it would take a lot more
> > work on my part to try to match things up.  If I notice it, I will try
> > to in the future.
> 
> What about introducing a new tag like 'SmPL-Used:'? The used SmPL could
> be placed somewhere in the web. This would require only one line in
> the changelog: e.g.:
> 
> SmPL-Used: http://coccinelle.lip6.fr/sp.php#usb_submit_urb

There is no guarantee that this URL will be valid 5 or 10 years from now.

julia
---511516320-20773290-1263449132=:18724--
