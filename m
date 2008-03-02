Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbYCBIFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbYCBIFR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 03:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbYCBIFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 03:05:06 -0500
Received: from main.gmane.org ([80.91.229.2]:46612 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYCBIFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 03:05:05 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Gunter Ohrner <G.Ohrner@post.rwth-aachen.de>
Subject: Re: Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in	dm-crypt
Followup-To: gmane.linux.kernel.device-mapper.dm-crypt
Date: Sun, 02 Mar 2008 08:58:52 +0100
Message-ID: <fqdmmv$eov$1@ger.gmane.org>
References: <200802281924.03996.rrs@researchut.com>	<20080228232048.51e28c1d.akpm@linux-foundation.org>	<20080229184649.GJ1788@agk.fab.redhat.com>	<200803010029.18320.rrs@researchut.com> <47C9AEF3.7040507@redhat.com> <47C9AF8F.2050502@redhat.com> <fqcjj9$5bv$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: bras-co-85-197-3-127.westend.de
User-Agent: KNode/0.10.5
Cc: dm-crypt@saout.de, dm-devel@redhat.com
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gunter Ohrner wrote:
> * This patch seems to hurt performance, I got much lower thoughput and the

Mh, strange, today I cannot reproduce the performance degradation...

There seem to have been some factors in effect during my yesterday's tests
which I'm not aware of - anyway, currently throughput is fine while running
a 2.6.24.3 kernel with this patch applied.

Greetings,

  Gunter

