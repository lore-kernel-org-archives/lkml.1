Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbYJEK6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbYJEK6K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 06:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYJEK5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 06:57:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46975 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbYJEK5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 06:57:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: 2.6.27-rc8-git7: Reported regressions from 2.6.26
Date: Sun, 5 Oct 2008 13:02:20 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <20081005071421.GA17685@2ka.mipt.ru>
In-Reply-To: <20081005071421.GA17685@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810051302.20896.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 of October 2008, Evgeniy Polyakov wrote:
> Hi.
> 
> On Sat, Oct 04, 2008 at 07:28:42PM +0200, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11308
> > Subject		: tbench regression on each kernel release from 2.6.22 -&gt; 2.6.28
> > Submitter	: Christoph Lameter <cl@linux-foundation.org>
> > Date		: 2008-08-11 18:36 (55 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121847986119495&w=4
> > 		  http://marc.info/?l=linux-kernel&m=122125737421332&w=4
> 
> Just for the reference, this one regresses from the 2.6.23.

Still, tbench results from 2.6.26 are better than from 2.6.27-rc.
That's why it's still on the list, but if you think that's not relevant, please
let me know and I'll drop it.

Thanks,
Rafael
