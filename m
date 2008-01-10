Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYAKKZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYAKKZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 05:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757867AbYAKKYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 05:24:48 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:45785 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbYAKKYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 05:24:47 -0500
Date: Thu, 10 Jan 2008 21:58:24 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Cc: linux-mips@linux-mips.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [BUG][PATCH] fix broken software reset for Malta board
Message-ID: <20080110215824.GA20935@linux-mips.org>
References: <4782F180.7000104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4782F180.7000104@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 06:44:00AM +0300, Dmitri Vorobiev wrote:

> I noticed that the commit f197465384bf7ef1af184c2ed1a4e268911a91e3
> (MIPS Tech: Get rid of volatile in core code) broke the software
> reset functionality for MIPS Malta boards in big-endian mode.

Thanks, applied.

  Ralf
