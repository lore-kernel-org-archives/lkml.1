Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbZCFNue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbZCFNue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 08:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZCFNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 08:50:25 -0500
Received: from adsl99-243.ath.forthnet.gr ([79.103.126.243]:44893 "EHLO
	vergina.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZCFNuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 08:50:24 -0500
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2009 08:50:24 EST
Message-ID: <49B127AB.6070202@asyr.hopto.org>
Date: Fri, 06 Mar 2009 15:39:55 +0200
From: Thanasis <thanasis@asyr.hopto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090112)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: jffs2 and kernel config for SDHC Memory Cards
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I want to use two of these Transcend¢s Class 6 SDHC (SD High-Capacity)
Memory Cards,
http://www.transcendusa.com/Products/ModDetail.asp?ModNo=147&LangNo=0&Func1No=1&Func2No=13
as part of the filesystem in a netbook (Acer A110L), will mount /home on
one, and /tmp and /var on the other.

Q1: Should I format them as jffs2?

Q2: What modules/configuration options should I enable in the kernel
(2.6.28) ?

# uname -a
Linux atom 2.6.28-gentoo-r2 #1 SMP PREEMPT Fri Mar 6 00:00:27 EET 2009
i686 Intel(R) Atom(TM) CPU N270 @ 1.60GHz GenuineIntel GNU/Linux
:-)

