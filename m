Return-Path: <linux-kernel-owner+w=401wt.eu-S1754137AbYI3Waw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbYI3Waw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 18:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYI3Wan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 18:30:43 -0400
Received: from xenotime.net ([66.160.160.81]:48196 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752929AbYI3Wan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 18:30:43 -0400
Date: Tue, 30 Sep 2008 15:49:08 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alessandro Rubini <ar@gnudd.com>,
       Alessandro Rubini <rubini@vision.unipv.it>
Subject: Re: About the maintainer of "MOUSE AND MISC DEVICES"
Message-Id: <20080930154908.aaf80a11.rdunlap@xenotime.net>
In-Reply-To: <alpine.LNX.1.10.0809302340190.4022@jikos.suse.cz>
References: <20080930153708.GX18732@tekkaman>
	<Pine.LNX.4.64.0809302248150.2307@twin.jikos.cz>
	<20080930230644.107e6428.kristoffer.ericson@gmail.com>
	<alpine.LNX.1.10.0809302340190.4022@jikos.suse.cz>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2008 23:54:57 +0200 (CEST) Jiri Kosina wrote:

> On Tue, 30 Sep 2008, Kristoffer Ericson wrote:
> 
> > > I in fact never understood what this maintainers entry meant ... what 
> > > is the device in question here?
> > I thought mouse was a part of linux-input? Or am I missing something?
> 
> It is. Generic mice interface is maintained by Dmitry as part of linux 
> input subsystem, and USB mice (usb hid) is maintained by me.

Ack.  And there is no MISC maintainer, so Jiri's patch to remove the
entire entry makes sense IMO.

---
~Randy
