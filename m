Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbYHEPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbYHEPJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbYHEPAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 11:00:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46057 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759726AbYHEPAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 11:00:06 -0400
Date: Tue, 5 Aug 2008 11:00:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: "Dasgupta, Romit" <romit@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Greg KH <greg@kroah.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] [PM] Fixes missing PM entries in sysfs without
 CONFIG_PM_SLEEP
In-Reply-To: <48986797.5090007@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0808051059280.2518-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008, David Engraf wrote:

> Is there an option to make a patch for the recent 2.6.26.1 kernel, so
> that I can use the next 2.6.26.2 kernel instead of waiting a few months
> for the next big release?

After the patch gets accepted, we can submit it for the 2.6.26-stable 
series.  Remind me in case I forget.

Alan Stern

