Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbYL3IjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbYL3IjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 03:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYL3Iiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 03:38:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:45987 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYL3Iiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 03:38:51 -0500
Subject: [PATCH -net-next 0/4] firmware patches for net drivers
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: David Miller <davem@davemloft.net>, davem@redhat.com,
       Jeff Garzik <jeff@garzik.org>, jgarzik@redhat.com, linux.nics@intel.com,
       e1000-devel@lists.sourceforge.net, netdev <netdev@vger.kernel.org>,
       jes@sgi.com, becker@scyld.com, David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Content-Type: text/plain
Date: Tue, 30 Dec 2008 13:53:34 +0530
Message-Id: <1230625414.24796.8.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are floating in linux-next trees from long time but now we are
sending these patches directly to the appropriate maintainers/mailing lists
so that they apply through proper channel.

1. firmware: convert e100 driver to request_firmware()
2. firmware: convert acenic driver to request_firmware()
3. firmware: convert tg3 driver to request_firmware()
4. starfire: use request_firmware()

Thank you,
	JSR

