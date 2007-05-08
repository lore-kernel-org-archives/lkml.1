Return-Path: <linux-kernel-owner+w=401wt.eu-S1032010AbXEHUGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032010AbXEHUGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031997AbXEHUGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:06:35 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:34827 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031989AbXEHUGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:06:32 -0400
X-YMail-OSG: D4UDviAVM1mQ9K5QvVHuwPgMLiu8Zpb5FkHuG6UoDwwligPP1lWG5gTXomAt81f1NNv5z5_b4A--
Date: Tue, 8 May 2007 13:06:28 -0700
From: Chris Wedgwood <cw@f00f.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Type cast some size_t arguments to 'unsigned int' to avoid (harmless) gcc printk warnings.
Message-ID: <20070508200628.GA31461@tuatara.stupidest.org>
References: <20070508185142.9ED501827261@tuatara.stupidest.org> <20070508200319.GA7035@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508200319.GA7035@martell.zuzino.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:03:19AM +0400, Alexey Dobriyan wrote:

> For one, size_t should be printed with %zu.

thanks, i wasn't aware of this

> For two, this is already fixed in mainline.

this was against mainline that wasn't more than an hour old when i
sent the patch
