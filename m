Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbZJBBix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbZJBBix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932134AbZJBBiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:38:51 -0400
Received: from gateway13.websitewelcome.com ([67.18.94.12]:48433 "HELO
	gateway13.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932126AbZJBBit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:38:49 -0400
X-Greylist: delayed 19199 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 21:38:49 EDT
Subject: clownix-spy plots any kernel variable history
From: clownix <clownix@clownix.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 01 Oct 2009 22:12:12 +0200
Message-Id: <1254427932.5670.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator713.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - clownix.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have made a tool at http://clownix.net which can plot qdisc
enqueues/dequeues/drops...

But the qdisc spy is only given as an example, basically any kernel
variable can be plotted after you have writen only a few lines in a
module, in this module, you subscribe to the klownix module and then the
klownix kernel thread periodically gathers the variables and sends them
through the netlink socket to a user daemon. A gtk interface requests
the plotting of the history of the variable.

The package contains a little test of visualization of the hfsc qdisc in
action.

If you visit the clownix site, beware, the tool is not the Cloonix-Net
which is another project altogether.

Regards
Vincent Perrier



