Return-Path: <linux-kernel-owner+w=401wt.eu-S1758337AbYFBIhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337AbYFBIhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYFBIh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:37:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58604 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130AbYFBIh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:37:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [Bug #10741] bug in `tty: BKL pushdown'?
Date: Mon, 2 Jun 2008 10:37:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <UJSav77TyUB.A.llE.zrZQIB@albercik> <878wxotfto.fsf@saeurebad.de>
In-Reply-To: <878wxotfto.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806021037.35384.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 of June 2008, Johannes Weiner wrote:
> Hi,

Hi,
 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10741
> > Subject		: bug in `tty: BKL pushdown'?
> > Submitter	: Johannes Weiner <hannes@saeurebad.de>
> > Date		: 2008-05-18 2:16 (14 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121107706506181&amp;w=4
> > Handled-By	: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> Bug still exists in Linus' current tree.

Thanks for the update.

Alan says it's a user space bug, though.

Rafael
