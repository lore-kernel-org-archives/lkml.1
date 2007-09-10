Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXIJUud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXIJUud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760624AbXIJUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:50:26 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2953 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760476AbXIJUuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:50:25 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Health monitor of a multi-threaded process
Date: Mon, 10 Sep 2007 13:50:14 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEEIGLAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <46E5643D.50005@redhat.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 10 Sep 2007 13:51:02 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 10 Sep 2007 13:51:02 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >     4) Threads are not in any infinite loop.

> This requires solving the Halting Problem.  If your management is
> demanding this
> feature, I suggest informing them that it is mathematically impossible.

Christ, these academics! They take real world problems that engineers
actually *solve* every day and then "prove" they're impossible.

Actually, it's trivial to solve this. Just wait. If the thread terminates,
it wasn't in an infinite loop.

If you've got the budget, I believe SGI has a machine that can do an
infinite loop in less than five seconds. That will save a lot of waiting.

DS


