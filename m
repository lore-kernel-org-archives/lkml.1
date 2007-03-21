Return-Path: <linux-kernel-owner+w=401wt.eu-S933815AbXCUT7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815AbXCUT7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933917AbXCUT7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:59:34 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1907 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815AbXCUT7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:59:33 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Why is /dev on a different filesystem ? [Kernel 2.6.20.3]
Date: Wed, 21 Mar 2007 12:59:29 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKKEPPCGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <04ea01c76bed$11b0d050$4b00a8c0@donald>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 12:59:39 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 21 Mar 2007 12:59:41 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So, obviously, /dev is on /, but the stat(2) says no.
> Who is right, and where is the bug ?
> 
> Kernel 2.4 had it right : /dev was on /, no doubt.

Have a look at the contents of /proc/mounts and all will be clear.

DS


