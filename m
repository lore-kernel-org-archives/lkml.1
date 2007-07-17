Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXGQVyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXGQVyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936443AbXGQVxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:53:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:30362 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935125AbXGQVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:53:32 -0400
Date: Tue, 17 Jul 2007 14:55:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org, "Greg KH" <greg@kroah.com>,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-Id: <20070717145509.9043ba39.randy.dunlap@oracle.com>
In-Reply-To: <200707171703.31340.rob@landley.net>
References: <200707171703.31340.rob@landley.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 17:03:31 -0400 Rob Landley wrote:

> Here's some sysfs/hotplug/firmware loading documentation I wrote.  I finally 
> tracked down the netlink bits to finish it up, so I can send it out to the 
> world.
> 
> What's wrong with it? :)

(1.  It's an attachment. :)


2.  Here's a C program to print hotplug nelink events to stdout:

s/nelink/netlink/

3.  See Documentation/firmware_class for more information.

Perhaps add a '/' after "firmware_class" to indicate a directory?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
