Return-Path: <linux-kernel-owner+w=401wt.eu-S1762661AbXHWMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762661AbXHWMZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbXHWMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:25:33 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4560 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760029AbXHWMZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:25:32 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7,v2.6.20.16
Date: Thu, 23 Aug 2007 05:24:41 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMENNGFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070823102523.GA5430@elte.hu>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 05:25:20 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 05:25:20 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > By popular demand, here is release -v20 of the CFS scheduler. It is a 
> > full backport of the latest & greatest v2.6.23-rc3 CFS code to 
> > v2.6.22.5, v2.6.21.7 and v2.6.20.16. The patches can be downloaded 
> > from the usual place:
> 
> update: i missed a small SMP balancing fix so i've updated the patches 
> to -v20.1.
> 
> 	Ingo

$ diff sched-cfs-v2.6.23-v20.patch sched-cfs-v2.6.23-v20.1.patch 
$ 

It's not funny unless you change something, IMO.

DS


