Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbZGNPj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbZGNPj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 11:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbZGNPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 11:39:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbZGNPj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 11:39:28 -0400
Date: Tue, 14 Jul 2009 17:39:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
Cc: imre.deak@nokia.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media/omap: adding __init/__exit macros to lcd_drivers
In-Reply-To: <200907031439.40456.PeterHuewe@gmx.de>
Message-ID: <alpine.LNX.2.00.0907141738580.813@wotan.suse.de>
References: <200907031439.40456.PeterHuewe@gmx.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-209977646-1247585966=:813"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-209977646-1247585966=:813
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Fri, 3 Jul 2009, Peter Hüwe wrote:

> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Trivial patch which adds the __init and __exit macros to the module_init /
> module_exit functions to several files in drivers/video/omap/

Applied to trivial queue, thanks.

-- 
Jiri Kosina
SUSE Labs
--168427776-209977646-1247585966=:813--
