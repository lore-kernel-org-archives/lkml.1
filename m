Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYAGXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYAGXXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYAGXX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:23:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34227 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbYAGXX0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:23:26 -0500
Date: Mon, 7 Jan 2008 15:23:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Claim maintainership for block2mtd and update email
 addresses
Message-Id: <20080107152300.2ed7cddb.akpm@linux-foundation.org>
In-Reply-To: <20080106135600.GB3120@lazybastard.org>
References: <20080106135600.GB3120@lazybastard.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 14:56:01 +0100
J__rn Engel <joern@lazybastard.org> wrote:

> - * Copyright (C) 2004-2006	Jörn Engel <joern@wh.fh-wedel.de>
> + * Copyright (C) 2004-2006	Joern Engel <joern@lazybastard.org>

Yup.  Your name comes out like that when sylpheed does its
save-email-to-a-file thing as well and I haven't got around to working out
why, or to reporting it.

In this case it looks like the dud characters came about due to "[MTD] Fix
legacy character sets throughout drivers/mtd, include/linux/mtd".  Which
doesn't look like it fixed anything much really.

Going with the asciified/anglicised/bastardised spelling is a practical
(albeit unhappy) solution.


