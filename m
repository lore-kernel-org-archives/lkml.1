Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbXKFKos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbXKFKos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754619AbXKFKol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:44:41 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:44481 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXKFKok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:44:40 -0500
Date: Tue, 6 Nov 2007 10:44:31 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MIPS:  Delete now-unreferenced i2c-yosemite.h header
	file.
Message-ID: <20071106104431.GD24844@linux-mips.org>
References: <Pine.LNX.4.64.0711060149350.3143@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711060149350.3143@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 01:55:12AM -0500, Robert P. J. Day wrote:

> Given that the corresponding source file i2c-yosemite.c file was
> removed in commit daa4a68f901c4d6491baa1a01f5c869a553c3f6c, and that
> no one else includes this file, it seems safe to delete it.

Thanks, queue for 2.6.25.

  Ralf
