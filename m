Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXBGWPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXBGWPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:15:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422912AbXBGWPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:15:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40670 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXBGWPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:15:40 -0500
Date: Wed, 7 Feb 2007 14:15:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Cedric Le Goater" <clg@fr.ibm.com>
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
Message-Id: <20070207141532.9c1ac548.akpm@linux-foundation.org>
In-Reply-To: <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net>
	<45CA0065.80705@fr.ibm.com>
	<6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 23:03:04 +0100
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> Hi Andrew,
> 
> On 07/02/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> > akpm@linux-foundation.org wrote:
> > > The mm snapshot broken-out-2007-02-06-16-59.tar.gz has been uploaded to
> > >
> > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz
> >
> > I'm having download issues : wrong modes :(
> >
> > ftp.kernel.org:/pub/linux/kernel/people/akpm/mm> ls
> > ...
> > -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.gz.sign
> > -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.sign
> > -rw-r-----    1 536      536       4065035 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2
> > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2.sign
> > -rw-r-----    1 536      536       5000290 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz
> > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz.sign
> > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.sign
> >
> 
> I still can't wget it...

You probably can compile it either.

> Can you upload a new snapshot (broken-out-2007-02-06-16-59 + latest
> 80+ patches)?

I copied it to
http://userweb.kernel.org/~akpm/broken-out-2007-02-06-16-59.tar.gz but
there's really not much point in using it - it's ancient.

