Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYAEXgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYAEXgx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 18:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbYAEXgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 18:36:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbYAEXgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 18:36:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc6-git12: Reported regressions from 2.6.23
Date: Sun, 6 Jan 2008 00:39:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>
References: <200801052042.56042.rjw@sisk.pl> <20080105200615.45236ffb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080105200615.45236ffb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801060039.09930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of January 2008, Alan Cox wrote:
> > Subject		: PATA_HPT37X embezzles two ports
> > Submitter	: "Bjoern Olausson" <lkmlist@gmail.com>
> > Date		: 2007-12-12 11:05
> > References	: http://lkml.org/lkml/2007/12/12/161
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9551
> 
> HPT374 patch was posted.

Udated status, thanks.

> We also have a newly reported regression in USB pl2303
> 
> See [pl2303 regression] Linux 2.6.23 breaks gpsbabel's DG-100 support on
> linux-usb@vger.kernel.org
> 
> No bug # yet but will try and sort a patch out next week.

Well, that's not a regression from 2.6.23.
