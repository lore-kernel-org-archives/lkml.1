Return-Path: <linux-kernel-owner+w=401wt.eu-S1764870AbXJOUjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764870AbXJOUjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbXJOUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:39:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59970 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbXJOUjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:39:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joseph Fannin <jfannin@gmail.com>
Subject: Re: 2.6.23-mm1 pm_prepare() and _finish() w/ args vs. without
Date: Mon, 15 Oct 2007 22:55:06 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Domen Puncer <domen.puncer@telargo.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071014194719.GB11864@nineveh.local> <200710142220.50299.rjw@sisk.pl>
In-Reply-To: <200710142220.50299.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710152255.06734.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 14 October 2007 22:20, Rafael J. Wysocki wrote:
> On Sunday, 14 October 2007 21:47, Joseph Fannin wrote:
> > On Sat, Oct 13, 2007 at 09:13:13PM +0200, Rafael J. Wysocki wrote:
> > 
> > > Yes.  Corrected patch follows.
> > 
> > A bit more is needed due to the rename of lite5200_pm_init() to
> > lite5200_suspend_init().
> 
> Well, I didn't intend to change it. :-)
> 
> > An amended patch follows that builds and boots on my powermac.
> 
> Thanks.
> 
> Can you please try the alternative one below?
> 
> I just removed the renaming of lite5200_pm_init() from it.

Well, from the lack of response I gather it works. :-)

I'm going to send it in a separate thread with a changelog.  Please object if
it doesn't work.

Greetings,
Rafael
