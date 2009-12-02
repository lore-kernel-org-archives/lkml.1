Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZLBUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZLBUYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 15:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbZLBUYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 15:24:36 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:61909 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999AbZLBUYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 15:24:35 -0500
Date: Wed, 2 Dec 2009 12:24:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       Marek Lindner <lindner_marek@yahoo.de>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       devel@driverdev.osuosl.org
Subject: Re: linux-next: Tree for December 2 (staging/batman-adv/)
Message-Id: <20091202122412.ddbe8682.randy.dunlap@oracle.com>
In-Reply-To: <20091202171931.5092dd32.sfr@canb.auug.org.au>
References: <20091202171931.5092dd32.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B16CCF9.0008:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Kconfig file:

config BATMAN_DEBUG
	bool "B.A.T.M.A.N. debugging"
	depends on BATMAN != n

s/BATMAN/BATMAN_ADV/


thanks.
---
~Randy
