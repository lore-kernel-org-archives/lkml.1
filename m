Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbXHBG7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbXHBG7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 02:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751982AbXHBG7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 02:59:09 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:47845 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXHBG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 02:59:08 -0400
Date: Thu, 2 Aug 2007 15:58:40 +0900
From: Mattia Dongili <malattia@linux.it>
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make struct sony_nc_ids[] static
Message-ID: <20070802065840.GG25969@inferi.kami.home>
References: <20070729145806.GU16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070729145806.GU16817@stusta.de>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.23-rc1-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 04:58:06PM +0200, Adrian Bunk wrote:
> sony_nc_ids[] can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>

imported locally, I'll send it to Len asap.
Thanks
-- 
mattia
:wq!
