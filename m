Return-Path: <linux-kernel-owner+w=401wt.eu-S1754408AbXLCEv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbXLCEv0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 23:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbXLCEvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 23:51:15 -0500
Received: from waste.org ([66.93.16.53]:41820 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752484AbXLCEvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 23:51:14 -0500
Date: Sun, 2 Dec 2007 22:50:59 -0600
From: Matt Mackall <mpm@selenic.com>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [1/4] dst: Distributed storage documentation.
Message-ID: <20071203045059.GM17536@waste.org>
References: <11963408033624@2ka.mipt.ru> <11963408034050@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11963408034050@2ka.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 03:53:23PM +0300, Evgeniy Polyakov wrote:
> 
> Distributed storage documentation.
> 
> Algorithms used in the system, userspace interfaces
> (sysfs dirs and files), design and implementation details
> are described here.

Can you give us a summary of how this differs from using device mapper
with NBD?

-- 
Mathematics is the supreme nostalgia of our time.
