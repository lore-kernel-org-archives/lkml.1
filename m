Return-Path: <linux-kernel-owner+w=401wt.eu-S967931AbXG3Uem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967931AbXG3Uem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 16:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966655AbXG3Uee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 16:34:34 -0400
Received: from websiteout12.httpserveur.net ([67.15.80.77]:47499 "HELO
	websiteout12.httpserveur.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966622AbXG3Uee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 16:34:34 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2007 16:34:34 EDT
X-Abuse: Please report all abuse immediately to abuse@httpserveur.net
Subject: New web-gui kernel monitoring tool: Clownix
From: clownix <clowncoder@clownix.net>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Jul 2007 22:27:50 +0200
Message-Id: <1185827270.10165.17.camel@perrier-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
At http://clownix.net is a new software that monitors lots of things:
qdiscs, bandwidths, cpu, ram ... and presents it in a beautifull web
gui (works for IE, firefox and probably lots of other browsers).
Ajax is used and the really good X lib at cross-browser.com which
makes little windows inside the web browser.

Note: the monitored data comes from a module belonging to the tool. 
the module transmit the monitored kernel data through a netlink socket.

No screenshots, but very easy to try.
Bye
Vincent Perrier

