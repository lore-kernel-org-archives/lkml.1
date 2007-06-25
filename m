Return-Path: <linux-kernel-owner+w=401wt.eu-S1756651AbXFYFLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651AbXFYFLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 01:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752953AbXFYFLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 01:11:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55805 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbXFYFLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 01:11:16 -0400
Date: Sun, 24 Jun 2007 22:06:06 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Richard Hughes <hughsient@gmail.com>,
       "kay.sievers" <kay.sievers@vrfy.org>,
       "Bryn M. Reeves" <breeves@redhat.com>, John Lenz <lenz@cs.wisc.edu>
Subject: Re: [patch] Move led attributes out of device name and into sysfs
	attributes, was Re: LED devices
Message-ID: <20070625050606.GC30043@kroah.com>
References: <1180710270.3782.5.camel@localhost.localdomain> <1180712592.6390.139.camel@localhost.localdomain> <1180713579.12843.8.camel@localhost.localdomain> <1180715004.6390.169.camel@localhost.localdomain> <20070608185710.GB14372@kroah.com> <1181343748.9506.116.camel@localhost.localdomain> <20070608234629.GA11723@kroah.com> <1181381117.24811.35.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181381117.24811.35.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 10:25:16AM +0100, Richard Purdie wrote:
> Anyhow, time to stop pretending I have any choice in this ;-). I will
> have the LED class use random numbers for busids and add a name
> attribute unless anyone else voices an opinion.

Thank you, I really appreciate it, and so does the people who write the
tools that parse sysfs (like HAL.)

greg k-h
