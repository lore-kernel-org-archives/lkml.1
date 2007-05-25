Return-Path: <linux-kernel-owner+w=401wt.eu-S1760333AbXEYLpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760333AbXEYLpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXEYLpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:45:33 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:46630 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXEYLpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:45:33 -0400
Date: Fri, 25 May 2007 13:45:50 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Geert.Uytterhoeven@sonycom.com
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 5/7] ps3: Disk Storage Driver
Message-ID: <20070525114550.GA32552@aepfle.de>
References: <20070525083607.784351000@sonycom.com> <20070525083632.575306000@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070525083632.575306000@sonycom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, Geert.Uytterhoeven@sonycom.com wrote:

> Add a Disk Storage Driver for the PS3:

There is no device symlink in /sys/block/ps3da/
