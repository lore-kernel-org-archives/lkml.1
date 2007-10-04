Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbXJDJvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbXJDJvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbXJDJvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:51:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57518 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXJDJvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:51:36 -0400
Date: Thu, 4 Oct 2007 11:51:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Pavel Machek <pavel@ucw.cz>
cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: CodingStyle: mention bitfields/whitespace style, prefer (!foo)
 in examples
In-Reply-To: <20071004094422.GA652@elf.ucw.cz>
Message-ID: <Pine.LNX.4.64.0710041151120.7253@fbirervta.pbzchgretzou.qr>
References: <20071004094422.GA652@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 4 2007 11:44, Pavel Machek wrote:
>diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
>index 7f1730f..1595a45 100644
>--- a/Documentation/CodingStyle
>+++ b/Documentation/CodingStyle
>@@ -71,6 +71,15 @@ used for indentation, and the above exam
> 
> Get a decent editor and don't leave whitespace at the end of lines.
> 
>+Bitfield variables should be indented like this:
>+
>+	unsigned int foo :1;

Current code uses foo:1.
