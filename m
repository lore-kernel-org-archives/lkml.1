Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbYF3NH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbYF3NH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYF3NHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:07:15 -0400
Received: from lazybastard.de ([212.112.238.170]:51272 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbYF3NHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:07:14 -0400
Date: Mon, 30 Jun 2008 15:06:52 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 1/3] atmel_nand speedup via {read,write}s{b,w}()
Message-ID: <20080630130652.GA28159@logfs.org>
References: <1214655248-15707-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1214655248-15707-1-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 June 2008 14:14:06 +0200, Haavard Skinnemoen wrote:
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> [haavard.skinnemoen@atmel.com: rebase onto atmel_nand rename]
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Acked-by: Andrew Victor <linux@maxim.org.za>

Acked-by: Joern Engel <joern@logfs.org>

Same goes for the other two patches in the series.

Jörn

-- 
Joern's library part 9:
http://www.scl.ameslab.gov/Publications/Gus/TwelveWays.html
