Return-Path: <linux-kernel-owner+w=401wt.eu-S1763441AbXIKLvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441AbXIKLvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXIKLvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:51:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:45839 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbXIKLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:51:45 -0400
Subject: Re: build #302 failed for 2.6.23-rc6-g0d4cbb5 in
	linux/drivers/mtd/chips/chipreg.o
From: David Woodhouse <dwmw2@infradead.org>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200709111337.05889.toralf.foerster@gmx.de>
References: <200709111337.05889.toralf.foerster@gmx.de>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Sep 2007 13:51:52 +0200
Message-Id: <1189511512.28687.10.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-3.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 13:37 +0200, Toralf Förster wrote:
> include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"

http://git.infradead.org/?p=mtd-2.6.git;a=commitdiff;h=241651d04d672fb685b2874707016cbbf95931e5

-- 
dwmw2

