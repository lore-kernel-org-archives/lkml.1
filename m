Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYGCOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYGCOOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYGCOOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:14:03 -0400
Received: from khc.piap.pl ([195.187.100.11]:52417 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYGCOOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:14:02 -0400
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Generic HDLC next tree
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 03 Jul 2008 16:13:59 +0200
Message-ID: <m3hcb7njh4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've setup a generic HDLC "next" tree (currently for 2.6.27) at

git://git.kernel.org/pub/scm/linux/kernel/git/chris/linux-2.6.git hdlc-next

This branch can be rebased or recreated at any time, hope it's ok for
"next". Currently based on 2.6.26-rc8.

Could you please include it in your "next" process?
Thanks.
-- 
Krzysztof Halasa
