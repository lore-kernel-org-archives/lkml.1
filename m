Return-Path: <linux-kernel-owner+w=401wt.eu-S1752172AbXBDIRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbXBDIRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 03:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXBDIRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 03:17:06 -0500
Received: from tag.witbe.net ([81.88.96.48]:49979 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXBDIRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 03:17:05 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: "'Jan Engelhardt'" <jengelh@linux01.gwdg.de>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       "'Andrew Morton'" <akpm@osdl.org>,
       "'Jon Masters'" <jonathan@jonmasters.org>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Subject: RE: [PATCH] Ban module license tag string termination trick
Date: Sun, 4 Feb 2007 09:14:57 +0100
Organization: AS2917.net
Message-ID: <006401c74834$8f927d70$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
In-Reply-To: <Pine.LNX.4.61.0702022006500.27603@yvahk01.tjqt.qr>
thread-index: AcdG/d9Hk6bdXZaZQmujZGgtrv4yiABNmosg
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So what (legally) happens when someone does
> MODULE_IS_UNDER_GPL_LICENSE(2), (~0) or (-1)? Does the judge 
> get confused?
> Then better use strings and an appropriate check.

Please let me not believe it's not possible to have a compilation test
on that that would issue a #error if param is not one of the acceptable
value...

Paul

