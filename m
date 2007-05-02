Return-Path: <linux-kernel-owner+w=401wt.eu-S2993164AbXEBV6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993164AbXEBV6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993161AbXEBV6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:58:14 -0400
Received: from www.osadl.org ([213.239.205.134]:45543 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767134AbXEBV6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:58:10 -0400
From: =?iso-8859-1?q?Hans-J=FCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 2/3] UIO: Documentation
Date: Thu, 3 May 2007 00:00:28 +0200
User-Agent: KMail/1.9.6
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org, tglx@linutronix.de
References: <20070427224957.GA17967@kroah.com> <200705021041.35422.hjk@linutronix.de> <20070502135237.59a46232.randy.dunlap@oracle.com>
In-Reply-To: <20070502135237.59a46232.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705030000.29272.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 02 Mai 2007 schrieb Randy Dunlap:
> On Wed, 2 May 2007 10:41:35 +0200 Hans-Jürgen Koch wrote:
> > Am Mittwoch 02 Mai 2007 01:42 schrieb Randy Dunlap:
> > > > +<title>The Userspace I/O HOWTO</title>
> > >
> > > Most of this reads well.  Thanks.
> > > A few typo corrections are below...
> >
> > Thank you for your work. I generated a new patch that includes all your
> > suggestions and also fixes the build problems.
>
> Hi,
> What does your patch apply to, please?  I get patch errors with it.
>

The patch goes on top of Greg's original patch plus the one I recently 
sent (adding the chapter about the userspace driver part). 
If you haven't got it handy, I mean this one:

http://marc.info/?l=linux-kernel&m=117788526325956&w=2

Thanks,
Hans


