Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbXLWBS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbXLWBS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbXLWBSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:18:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43669 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbXLWBST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:18:19 -0500
Subject: Re: [Cbe-oss-dev] [announce] PS3 Linux Distributor's Starter Kit
	(v1.5.1) released
From: David Woodhouse <dwmw2@infradead.org>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: linux-kernel@vger.kernel.org, cbe-oss-dev@ozlabs.org
In-Reply-To: <476C3285.2060502@am.sony.com>
References: <4581CA0C.20102@am.sony.com>  <476C3285.2060502@am.sony.com>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 01:18:15 +0000
Message-Id: <1198372695.11901.92.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-12-21 at 13:39 -0800, Geoff Levand wrote:
> An updated kboot image is here:
> 
> http://www.kernel.org/pub/linux/kernel/people/geoff/cell/kboot-20071220.bld

NFS booting seems to fail. After saying 'Mounting ...' for 30 seconds or
so, it then says 'rpcbind: server 0.0.0.0 not responding, timed out'.

-- 
dwmw2

