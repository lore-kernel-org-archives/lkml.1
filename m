Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbZFNUuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbZFNUuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761312AbZFNUuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:50:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756532AbZFNUuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:50:07 -0400
Date: Sun, 14 Jun 2009 22:50:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Meyer <thomas@m3y3r.de>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: 2.6.30: suspend-to-ram, second s2r wakes up immediately
In-Reply-To: <200906142129.08135.rjw@sisk.pl>
Message-ID: <alpine.LNX.2.00.0906142246120.7457@wotan.suse.de>
References: <1244996001.8440.10.camel@localhost> <200906142031.38358.elendil@planet.nl> <1245006429.23043.2.camel@localhost> <200906142129.08135.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Jun 2009, Rafael J. Wysocki wrote:

> As for the mouse itself, I don't know.  I'm not even sure if it's 
> possible at all (CCing Jiri).

The main question is whether the mouse really is generating wakeup event 
even if unused.

Could you please provide usbmon dumps (Documentation/usb/usbmon.txt) from 
the failing suspend session?

Thanks,

-- 
Jiri Kosina
SUSE Labs
