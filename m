Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbXFVDj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbXFVDj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 23:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFVDjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 23:39:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49649 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbXFVDjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 23:39:19 -0400
Subject: Re: [RFC: 2.6 patch] schedule BLK_DEV_IDE_SATA for removal
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070621235211.GH23017@stusta.de>
References: <20070621235211.GH23017@stusta.de>
Content-Type: text/plain
Date: Fri, 22 Jun 2007 11:39:45 +0800
Message-Id: <1182483586.10524.33.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-22 at 01:52 +0200, Adrian Bunk wrote:
> Users should use the libata based drivers for SATA drives.

NAK. Not all IDE drivers are converted yet. Not even all the relatively
common ones.

-- 
dwmw2

