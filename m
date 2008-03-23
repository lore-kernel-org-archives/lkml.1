Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYCWTk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYCWTk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 15:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755449AbYCWTkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 15:40:14 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:33811 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbYCWTkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 15:40:12 -0400
From: Chr <chunkeey@web.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Milan Broz <mbroz@redhat.com>,
       dm-crypt@saout.de, Alasdair G Kergon <agk@redhat.com>
Subject: Re: 2.6.25-rc5-git6: Reported regressions from 2.6.24
Date: Sun, 23 Mar 2008 20:40:08 +0100
User-Agent: KMail/1.9.9
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
References: <200803170018.52663.rjw@sisk.pl> <alpine.DEB.1.00.0803231955530.13579@sheep.housecafe.de> <200803232006.57198.rjw@sisk.pl>
In-Reply-To: <200803232006.57198.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803232040.09964.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX1/XCubeoVZfZq4z9SdgCcpWzKZifE2IOcRR3Ojj
	jYvKJKf7de74xxXtGj60R6DizKl0RgnK0dYxjCoPT2x21YI+SP
	AzoXlmqJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 March 2008 20:06:56 Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > > Subject		: INFO: task mount:11202 blocked for more than 120 seconds
> > > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > > Date		: 2008-03-07 21:32 (10 days old)
> > > References	: http://lkml.org/lkml/2008/3/7/308
> > > 		  http://lkml.org/lkml/2008/3/9/186
> >
> > The other Christian reported this as fixed:
> > http://lkml.org/lkml/2008/3/17/232 I too can confirm that the hangs are
> > gone now: http://lkml.org/lkml/2008/3/21/532
>
> Is the patch present in the mainline yet?
No... it isn't in the mainline?! (or was is commited as I wrote this mail?!) 
anyway, can someone please merge the patch there?

http://lkml.org/lkml/2008/3/17/214

Regards,
	Christian
