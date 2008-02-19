Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbYBSXQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbYBSXQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761391AbYBSXQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:16:16 -0500
Received: from lax-green-bigip-5.dreamhost.com ([208.113.200.5]:38450 "EHLO
	spaceymail-a2.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761044AbYBSXQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:16:15 -0500
Date: Wed, 20 Feb 2008 10:21:14 +1100
From: "Carlos E. M. Dyonisio" <cadu@nerdfeliz.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: balajirrao@gmail.com, gregkh@suse.de
Subject: 2.6.25-rc2 regression: kobject handling in cpufreq doesn't allow
 the system to power off
Message-Id: <20080220102114.307a97a9.cadu@nerdfeliz.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using the latest Linus' git tree, and the bug with cpufreq not allowing
the system to power off is still there.

With the patch sent some days ago (http://lkml.org/lkml/2008/2/8/346), it
works fine. There is also a bugzilla entry for this bug here:
http://bugzilla.kernel.org/show_bug.cgi?id=9960

Any ideas of when will this patch be going to mainline?

Cheers,
Carlos
-- 
Carlos Eduardo Medaglia Dyonisio
cadu@nerdfeliz.com
http://nerdfeliz.com/
