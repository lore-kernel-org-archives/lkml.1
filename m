Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKMKdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKMKdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 05:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYKMKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 05:33:32 -0500
Received: from main.gmane.org ([80.91.229.2]:35855 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYKMKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 05:33:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jeremy Sanders <jeremy@jeremysanders.net>
Subject: Re: NFS root hangs
Date: Thu, 13 Nov 2008 10:33:16 +0000
Message-ID: <gfgvpc$h3g$1@ger.gmane.org>
References: <gfc3oh$85h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: xpc17.ast.cam.ac.uk
User-Agent: KNode/0.10.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Sanders wrote:

> Hi - We're running several diskless x86-64 systems with a MS-6702
> motherboard with an Athlon 64 3400+ CPU. The network driver is an onboard
> R8169 (rev 10) using gigabit ethernet. The kernel is 2.6.26.6-49.fc8 (i.e.
> the latest Fedora 8 kernel). The root partition is mounted over NFS (v3)
> in an initrd init script.
> 
> This setup works fine for some dual core Athlon 64s and single core x86
> Pentium 4s. However the diskless single core Athlon 64 systems lock up
> randomly after minutes or tens of minutes of idleness.

Just to report they also hang with 2.6.27.5, but it takes a few hours of
usage to hang now rather than tens of minutes.

Jeremy


