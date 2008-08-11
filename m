Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbYHKUyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbYHKUyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:54:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbYHKUx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:53:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbYHKUx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:53:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rabin Vincent <rabin@rab.in>
Subject: Re: [Bug #11231] gspca_zc3xx oops - 2.6.27-rc1
Date: Mon, 11 Aug 2008 22:56:49 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Parag Warudkar <parag.warudkar@gmail.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.g4B.pDjnIB@albercik> <20080811154101.GA1667@debian>
In-Reply-To: <20080811154101.GA1667@debian>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808112256.49750.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 of August 2008, Rabin Vincent wrote:
> On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11231
> > Subject		: gspca_zc3xx oops - 2.6.27-rc1
> > Submitter	: Parag Warudkar <parag.warudkar@gmail.com>
> > Date		: 2008-08-02 16:22 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121769418920774&w=4
> > Handled-By	: Rabin Vincent <rabin@rab.in>
> > Patch		: http://marc.info/?l=linux-kernel&m=121774908213124&w=4
> 
> This can be closed.  The patch is now in mainline as
> fcf5cb2406827fc9d3f3fe260ac883ef72b8bac0 ("V4L/DVB (8605): gspca: Fix of
> gspca_zc3xx oops - 2.6.27-rc1").

Thanks, closed.

Rafael
