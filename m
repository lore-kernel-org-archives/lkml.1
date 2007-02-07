Return-Path: <linux-kernel-owner+w=401wt.eu-S1422907AbXBGWVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbXBGWVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 17:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030662AbXBGWVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 17:21:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:43607 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030661AbXBGWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 17:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gnsjiUjIaRIeKe/51VVEFFH/KsokJh0Fu+uqJ3cNi5c3qUIjkp4NanxziL/ZH4w7WtIF84XZJ+HUXHACFSBS1jxGl/H9JPC+qGjj90QAWS1IoZgZ76iIn/VifIHrgQDImy6pDcaj9dIVnPZrtGJPRUW0ovh5VNntYOSUfRO+wqo=
Message-ID: <6bffcb0e0702071421o346f35i3955a94467fe62ae@mail.gmail.com>
Date: Wed, 7 Feb 2007 23:21:34 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-02-06-16-59.tar.gz uploaded
Cc: linux-kernel@vger.kernel.org, "Cedric Le Goater" <clg@fr.ibm.com>
In-Reply-To: <20070207141532.9c1ac548.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702070059.l170xPY0002614@shell0.pdx.osdl.net>
	 <45CA0065.80705@fr.ibm.com>
	 <6bffcb0e0702071403v767681edk2179fdb968b57e5a@mail.gmail.com>
	 <20070207141532.9c1ac548.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 7 Feb 2007 23:03:04 +0100
> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
>
> > Hi Andrew,
> >
> > On 07/02/07, Cedric Le Goater <clg@fr.ibm.com> wrote:
> > > akpm@linux-foundation.org wrote:
> > > > The mm snapshot broken-out-2007-02-06-16-59.tar.gz has been uploaded to
> > > >
> > > >    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-02-06-16-59.tar.gz
> > >
> > > I'm having download issues : wrong modes :(
> > >
> > > ftp.kernel.org:/pub/linux/kernel/people/akpm/mm> ls
> > > ...
> > > -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.gz.sign
> > > -rw-rw-r--    1 536      536           248 Jan 28 08:31 broken-out-2007-01-28-00-31.tar.sign
> > > -rw-r-----    1 536      536       4065035 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2
> > > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.bz2.sign
> > > -rw-r-----    1 536      536       5000290 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz
> > > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.gz.sign
> > > -rw-r-----    1 536      536           248 Feb 07 00:59 broken-out-2007-02-06-16-59.tar.sign
> > >
> >
> > I still can't wget it...
>
> You probably can compile it either.
>
> > Can you upload a new snapshot (broken-out-2007-02-06-16-59 + latest
> > 80+ patches)?
>
> I copied it to
> http://userweb.kernel.org/~akpm/broken-out-2007-02-06-16-59.tar.gz but
> there's really not much point in using it - it's ancient.
>

It's time to improve witcher script :)
http://www.gossamer-threads.com/lists/linux/kernel/727199

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
