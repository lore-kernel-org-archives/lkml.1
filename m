Return-Path: <linux-kernel-owner+w=401wt.eu-S1030450AbXAYROK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030450AbXAYROK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 12:14:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030456AbXAYROK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 12:14:10 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:47267 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030450AbXAYROJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 12:14:09 -0500
Date: Thu, 25 Jan 2007 17:14:05 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Jan Altenberg <jan@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20-rc6][MIPS]Malta: trivial compile error fix
Message-ID: <20070125171405.GA24043@linux-mips.org>
References: <1169738756.18700.12.camel@jan-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1169738756.18700.12.camel@jan-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 25, 2007 at 04:25:56PM +0100, Jan Altenberg wrote:

> the following patch should fix a compile error for MIPS_MALTA, when
> CONFIG_MTD is disabled.

Thanks, applied.

Btw, git will strip anything below the "---" line from the log message,
so you better put the Signed-off-by: line before it.

  Ralf
