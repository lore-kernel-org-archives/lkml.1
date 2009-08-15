Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZHOU7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZHOU7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 16:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZHOU7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 16:59:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250AbZHOU7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 16:59:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
Date: Sat, 15 Aug 2009 23:00:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-acpi" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
References: <200908122218.13975.rjw@sisk.pl> <20090814163310.GE1626@ucw.cz>
In-Reply-To: <20090814163310.GE1626@ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908152300.32236.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Pavel Machek wrote:
> > The following patches introduce a mechanism allowing us to execute device
> > drivers' suspend and resume callbacks asynchronously during system sleep
> > transitions, such as suspend to RAM.  The idea is explained in the [1/1] patch
> > message.
> 
> it looks sane to me... Not too long and nice code :-)

Well, thanks.

Alan seems to have some reservations, though.

Rafael
