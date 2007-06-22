Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXFVFOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXFVFOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 01:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXFVFOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 01:14:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38756 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbXFVFOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 01:14:24 -0400
Subject: Re: [DOCS] make headers_install
From: David Woodhouse <dwmw2@infradead.org>
To: Rob Landley <rob@landley.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200706220004.27754.rob@landley.net>
References: <200706220004.27754.rob@landley.net>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 13:14:50 +0800
Message-Id: <1182489291.10524.43.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 00:04 -0400, Rob Landley wrote:
> Here's a really quick stab at documentation for make headers_install.
> 
> Comments?
> 
> --------------------
> 
> Exporting kernel headers for use by userspace (/usr/include/linux)

Also /usr/include/asm (and asm-* on biarch 64-bit architectures), along
with a few other directories. See $linux/include/Kbuild.

Other than that it looks relatively sane; thanks.

-- 
dwmw2

