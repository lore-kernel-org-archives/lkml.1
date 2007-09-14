Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbXINUBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbXINUBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 16:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbXINUBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 16:01:42 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47340 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbXINUBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 16:01:41 -0400
Date: Fri, 14 Sep 2007 22:01:40 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@qumranet.com>,
       Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH 2/3] Consolidate host virtualization support under
 Virtualization menu
In-Reply-To: <20070914091921.73007c5a.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0709142201110.10168@fbirervta.pbzchgretzou.qr>
References: <1189747054.7262.34.camel@localhost.localdomain>
 <1189747124.7262.36.camel@localhost.localdomain> <20070914091921.73007c5a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 14 2007 09:19, Randy Dunlap wrote:
>On Fri, 14 Sep 2007 15:18:44 +1000 Rusty Russell wrote:
>
>> We turn "Virtualization" into a menu, not a config option, since it's
>> actually only used as a menu.  Then we move lguest under that menu.

Whatever, keep it as menuconfig. I want to disable it _at once_
without having to enter the menu, which is the primary motivation
having it as 'menuconfig'.


	Jan
-- 
