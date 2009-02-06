Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbZBFOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbZBFOJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZBFOJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:09:36 -0500
Received: from smtpauth21.prod.mesa1.secureserver.net ([64.202.165.38]:54900
	"HELO smtpauth21.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753598AbZBFOJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:09:35 -0500
From: "Andrew S. Johnson" <andy@asjohnson.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #12426] TMDC Joystick no longer works in kernel 2.6.28
Date: Fri, 6 Feb 2009 08:09:21 -0600
User-Agent: KMail/1.9.9
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <a47yn9c9JrF.A.hz.L5YiJB@chimera> <alpine.LRH.1.10.0902041453190.22097@twin.jikos.cz> <200902050234.56056.rjw@sisk.pl>
In-Reply-To: <200902050234.56056.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902060809.21985.andy@asjohnson.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 07:34:55 pm Rafael J. Wysocki wrote:
> On Wednesday 04 February 2009, Jiri Kosina wrote:
> > On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a
> > > report of regressions introduced between 2.6.27 and 2.6.28.
> > >
> > > The following bug entry is on the current list of known
> > > regressions introduced between 2.6.27 and 2.6.28.  Please
> > > verify if it still should be listed and let me know (either
> > > way).
> > >
> > >
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12426
> > > Subject		: TMDC Joystick no longer works in kernel 2.6.28
> > > Submitter	: Andrew S. Johnson <andy@asjohnson.com>
> > > Date		: 2009-01-10 21:53 (26 days old)
> > > References	:
> > > http://marc.info/?l=linux-kernel&m=123162486415366&w=4
> >
> > I asked [1] the Submitter some time ago to check whether
> > reverting a particular commit fixes the issue, but never heard
> > back.
> >
> > [1] http://lkml.org/lkml/2009/1/26/70
>
> Rejected as "insufficient data" and closed.

I never received the email referring to a particular commit because
I am not subscribed to LKML.  The commit revert seemed to work OK on 
gameport.c, but I get an error that gameport.h requires merge 
resolution.

Can you send the gameport.c and gameport.h files to me with the
reverted commit, or tell me how to get this resolved?

Please CC me directly.

Thanks,

Andy Johnson

>
> Thanks,
> Rafael


