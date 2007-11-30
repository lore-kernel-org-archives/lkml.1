Return-Path: <linux-kernel-owner+w=401wt.eu-S934099AbXK3NRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934099AbXK3NRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbXK3NRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:17:31 -0500
Received: from qmta07.westchester.pa.mail.comcast.net ([76.96.62.64]:38528
	"EHLO QMTA07.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752321AbXK3NRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:17:31 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 08:17:30 EST
X-Authority-Analysis: v=1.0 c=1 a=YP7E5MQV5OkA:10 a=gGOXcrezqctCnY4jsNcA:9 a=VvQEADYkBPKNHs-yEfcA:7 a=dUR5LkvEnHIW-CSwXbGjqlDODI8A:4 a=-ZQhYGXY2L8A:10
Subject: re: pnpacpi : exceeded the max number of IO resources
From: Chris Holvenstot <cholvenstot@comcast.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 30 Nov 2007 07:14:48 -0600
Message-Id: <1196428488.7066.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

For what it is worth I too have seen this problem this morning and it
DOES appear to be new (in contrast to a previous comment)

The message:  pnpacpi: exceeded the max number of mem resources: 12

is displayed each time the system is booted with the 2.6.24-rc3-git5
kernel but is NOT displayed when booting 2.6.24-rc3-git4

I have made no changes in my config file between these two kernels other
than to accept any new defaults when running make oldconfig.

If you had already narrowed it down to a change between git4 and git5 I
apologize for wasting your time.  Have to run to work now.

Chris

