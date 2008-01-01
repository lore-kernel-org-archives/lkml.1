Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYAAQcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYAAQcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYAAQcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:32:16 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44350 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYAAQcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:32:15 -0500
Subject: Re: [2.6 patch] remove broken MTD drivers
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Thomas Gleixner <tglx@cruncher.tec.linutronix.de>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080101134839.GN2360@does.not.exist>
References: <20080101134839.GN2360@does.not.exist>
Content-Type: text/plain
Date: Tue, 01 Jan 2008 16:30:57 +0000
Message-Id: <1199205057.6315.67.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-01 at 15:48 +0200, Adrian Bunk wrote:
> This patch removes two MTD drivers that have been marked as
> BROKEN 19 months ago due to requiring nonexisting header files.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Any particular reason you didn't Cc the authors identified in the
drivers you're removing?

-- 
dwmw2

