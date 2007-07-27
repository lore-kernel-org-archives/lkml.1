Return-Path: <linux-kernel-owner+w=401wt.eu-S936647AbXG0MDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936647AbXG0MDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 08:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765020AbXG0MDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 08:03:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36204 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761189AbXG0MDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 08:03:34 -0400
Date: Fri, 27 Jul 2007 13:03:32 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Petr Stehlik <pstehlik@sophics.cz>
Cc: Yoann Padioleau <padator@wanadoo.fr>, kernel-janitors@vger.kernel.org,
       geert@linux-m68k.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/68] 0 -> NULL, for arch/m68k
Message-ID: <20070727120332.GX27237@ftp.linux.org.uk>
References: <200707270944.LAA17213@ifs.emn.fr> <46A9CF66.90108@sophics.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A9CF66.90108@sophics.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:56:38PM +0200, Petr Stehlik wrote:

> NULL is usually used when checking for an uninitialized pointer, right?

No, we use different LARTs when you do that.
