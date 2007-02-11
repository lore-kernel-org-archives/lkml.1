Return-Path: <linux-kernel-owner+w=401wt.eu-S1752732AbXBKFD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbXBKFD7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 00:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbXBKFD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 00:03:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:32907 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbXBKFD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 00:03:58 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Jens Axboe <jens.axboe@oracle.com>, linux-acpi@vger.kernel.org
Subject: Re: current git breaks resume
Date: Sun, 11 Feb 2007 00:02:38 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070209190307.GC6152@kernel.dk>
In-Reply-To: <20070209190307.GC6152@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702110002.38328.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 February 2007 14:03, Jens Axboe wrote:
> Hi,
> 
> Unfortunately I'm a little short on time as I'll be travelling tomorrow,
> but of course preparing a new kernel for the laptop is something you
> want to do right before leaving. So I discovered that the current (well
> as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
> doesn't resume on my x60. 2.6.20 works fine, so something broke since
> then.

resume from RAM, or resume from disk?

