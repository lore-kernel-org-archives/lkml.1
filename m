Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYFVVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYFVVBK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754572AbYFVVA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:00:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:38603 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYFVVA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:00:57 -0400
Date: Sun, 22 Jun 2008 14:00:44 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Adam Williamson" <awilliamson@mandriva.com>,
       "Alan Cox" <alan@redhat.com>
Subject: Re: [Bug #10868] Oops on loading ipaq module since 2.6.26, prevents
 use of device
Message-ID: <20080622140044.57dce6f2@infradead.org>
In-Reply-To: <20080622210706.0a90c4ba@lxorguk.ukuu.org.uk>
References: <RzbtSgMztjP.A.jRD._spXIB@albercik>
	<4mRZUF-hVeG.A.s6E.JupXIB@albercik>
	<20080622210706.0a90c4ba@lxorguk.ukuu.org.uk>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 21:07:06 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sun, 22 Jun 2008 19:54:46 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10868
> > Subject		: Oops on loading ipaq module since 2.6.26,
> > prevents use of device Submitter	: Adam Williamson
> > <awilliamson@mandriva.com> Date		: 2008-06-05 17:39
> > (18 days old) Handled-By	: Alan Cox <alan@redhat.com>
> 
> Handed over to Greg as it's not a tty layer bug but something in USB
> (actually from the traces I think its a broken gcc/build but we shall)

http://www.kerneloops.org/search.php?search=ipaq_open

has a whole slew of different ones.... surprisingly they're almost all
with pppd...



-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
