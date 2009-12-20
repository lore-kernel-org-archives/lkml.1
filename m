Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZLTDud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZLTDud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 22:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbZLTDuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 22:50:32 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39575 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754197AbZLTDuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 22:50:32 -0500
Date: Sat, 19 Dec 2009 22:50:31 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>
Subject: Re: 2.6.33-git0 regression: hard lock when connecting openmoko
In-Reply-To: <20091219215439.GA9011@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0912192249170.6618-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Dec 2009, Pavel Machek wrote:

> Hi!
> 
> ...that's pretty much it. It says "New high speed usb device" and
> cursor stops blinking :-(.

Do you get anything more if you enable CONFIG_USB_DEBUG?

Alan Stern

