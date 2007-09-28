Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXI1Sal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXI1Sal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 14:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbXI1Sa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 14:30:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755359AbXI1Sa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 14:30:26 -0400
Date: Fri, 28 Sep 2007 19:30:25 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ken Schmidt <kenneth.schmidt@pnl.gov>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/02] vfs: variant symlinks
Message-ID: <20070928183025.GW8181@ftp.linux.org.uk>
References: <20070928101601.0ccc1b74.kenneth.schmidt@pnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070928101601.0ccc1b74.kenneth.schmidt@pnl.gov>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 10:16:01AM -0700, Ken Schmidt wrote:
> Variant symlinks add the ability to embed variables in to the contents of symbolic links so their targets can change based on outside sources (user environment, uts, filesystems, etc.)

NAK - it's too ugly to live.
