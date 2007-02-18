Return-Path: <linux-kernel-owner+w=401wt.eu-S1752369AbXBRWrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbXBRWrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 17:47:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXBRWrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 17:47:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59871 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbXBRWrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 17:47:52 -0500
Date: Sun, 18 Feb 2007 14:47:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.20-mm2 -- EIP is at __make_request+0xeb/0x2ee
Message-Id: <20070218144743.3eff0299.akpm@linux-foundation.org>
In-Reply-To: <20070218143517.238d7a0e.akpm@linux-foundation.org>
References: <a44ae5cd0702181347l4551aaefxf083e5260ea274ce@mail.gmail.com>
	<20070218143517.238d7a0e.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 14:35:17 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> I guess I need to do a git-blockless -mm3

OK, this is looking like a pain - I'd have to drop or significantly redo
thirty or more patches.  Jens, please fix it asap.
