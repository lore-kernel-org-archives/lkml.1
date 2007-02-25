Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXBYLeJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXBYLeJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:34:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964805AbXBYLeJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:34:09 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2624 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804AbXBYLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:34:07 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: GPL vs non-GPL device drivers
Date: Sun, 25 Feb 2007 03:33:38 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKOEDMBNAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20070225104211.GB2045@elf.ucw.cz>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 25 Feb 2007 03:34:04 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 25 Feb 2007 03:34:05 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> But... how does situation change when Evil Linker does #include
> <pop3/gpl_header_file_with_some_inline_functions.h> from his
> binary-only part?

Right, but *why* is he doing that? The answer: It is the most practical way
to write his driver.

> I believe situation in this case changes a lot... And that's what
> embedded people are doing; I do not think they are creating their own
> headers or their own inline functions where headers contain them.

They don't have to. You *cannot* use copyright to make ideas harder to
express. That's what patents are for.

All the people who make this linking argument seem to be completely missing
the entire *point* of copyright. A copyright protects the *one* way you
chose to express a particular idea. It cannot protect function. It cannot
make other ideas harder to express.

This is not some loophole or something. This is the most fundamental thing
about copyrights that there is. This is the reason they're so easy to get.
This is the reason they last so long. They *cannot* impede interoperation.
They cannot make other ideas harder to express. They can't even make the
very same idea you expressed harder to express.

Copyrights are not patents.

It is clear, at least in the United States, that something like "a kernel
driver to make <some particular version of Linux> work with <some particular
piece of hardware>" is an idea. You cannot own all the most practical ways
to express that idea. When practical engineering concerns make one way (or
one group of ways) the most reasonable, you simply *cannot* own them all
with copyright.

DS


