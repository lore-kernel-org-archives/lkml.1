Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYFRTo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYFRTo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYFRToQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:44:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:33735 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbYFRToP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:44:15 -0400
Date: Wed, 18 Jun 2008 12:43:31 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, jeremy@xensource.com,
       chrisw@sous-sol.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       virtualization@lists.osdl.org
Subject: Re: linux-next: Tree for June 18 (XEN build error)
Message-Id: <20080618124331.04e27900.randy.dunlap@oracle.com>
In-Reply-To: <20080618175753.2a519b71.sfr@canb.auug.org.au>
References: <20080618175753.2a519b71.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-next-20080618/drivers/xen/manage.c: In function 'xen_suspend':
linux-next-20080618/drivers/xen/manage.c:66: error: too few arguments to function 'device_power_up'
linux-next-20080618/drivers/xen/manage.c: In function 'do_suspend':
linux-next-20080618/drivers/xen/manage.c:115: error: too few arguments to function 'device_resume'
make[3]: *** [drivers/xen/manage.o] Error 1

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
