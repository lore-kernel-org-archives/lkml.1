Return-Path: <linux-kernel-owner+w=401wt.eu-S1764532AbXKNVZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764532AbXKNVZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755270AbXKNVZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:25:23 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbXKNVZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:25:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Shane <ibm-main@tpg.com.au>
Subject: Re: 2.6.24-rc2 panic: (non-exitent) NFS root f/s
Date: Wed, 14 Nov 2007 22:42:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <1195046393.9513.19.camel@toshi>
In-Reply-To: <1195046393.9513.19.camel@toshi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711142242.51681.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 14 of November 2007, Shane wrote:
> New guy to this list. Long time lurker on CKRM - decided to test the
> control groups patches.
> Pulled 2.6.24.rc4 patch and migrated my (working) 2.6.23-rc4 config.
> 
> Panic'd because of NFS root not found - not too surprising as I don't
> have one.
> Any ideas why this option comes up selected ???. Same result if I "make
> oldconfig" or "make menuconfig" (after "make mrproper" in both cases).
> Maybe some weird combination of containers/cpusets/??? ...
> 
> What should I be looking for to troubleshoot ???.

Perhaps it just can't find the root filesystem at all?

Rafael
