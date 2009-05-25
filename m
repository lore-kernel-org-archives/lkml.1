Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZEYXRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZEYXRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbZEYXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:17:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41287 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbZEYXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:17:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #13125] active uvcvideo breaks over suspend
Date: Tue, 26 May 2009 01:17:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Ming Lei <tom.leiming@gmail.com>
References: <ZPPBiNHr1LC.A.9ZH.K9bGKB@chimera> <uSztiUhmDDC.A.B-B.0-bGKB@chimera> <4A1A6B59.2030009@tuffmail.co.uk>
In-Reply-To: <4A1A6B59.2030009@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260117.53340.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009, Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.29.  Please verify if it still should be listed and let me know
> > (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13125
> > Subject		: active uvcvideo breaks over suspend
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2009-04-15 10:12 (40 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123979009508840&w=4
> > Handled-By	: Ming Lei <tom.leiming@gmail.com>
> > Patch		: http://lkml.org/lkml/2009/4/18/5
> >   
> 
> Seems to be fixed in RC7, thanks.

Thanks, closed.

Rafael
