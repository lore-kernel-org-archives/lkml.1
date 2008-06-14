Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYFNDqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYFNDqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 23:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYFNDq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 23:46:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40153
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753027AbYFNDq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 23:46:28 -0400
Date: Fri, 13 Jun 2008 20:46:28 -0700 (PDT)
Message-Id: <20080613.204628.137971521.davem@davemloft.net>
To: hidave.darkstar@gmail.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, w@1wt.eu, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       arjan@linux.intel.com, marcel@holtmann.org, chrisw@sous-sol.org
Subject: Re: [patch 16/47] bluetooth: fix locking bug in the rfcomm socket
 cleanup handling
From: David Miller <davem@davemloft.net>
In-Reply-To: <a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
References: <20080614000840.GA24659@suse.de>
	<20080614001058.GP24698@suse.de>
	<a8e1da0806131950i4eb0ea48q5cc34ea07cfd523a@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Dave Young" <hidave.darkstar@gmail.com>
Date: Sat, 14 Jun 2008 10:50:51 +0800

> On Sat, Jun 14, 2008 at 8:10 AM, Greg KH <gregkh@suse.de> wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> > From: Arjan van de Ven <arjan@linux.intel.com>
> >
> > [ Upstream commit: 7dccf1f4e1696c79bff064c3770867cc53cbc71c ]
> 
> Hi greg
> Please including following commit as well because it will cause another bug:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=537d59af73d894750cff14f90fe2b6d77fbab15b

Acked-by: David S. Miller <davem@davemloft.net>
