Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXGERWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXGERWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 13:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759143AbXGERWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 13:22:39 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55820 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694AbXGERWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 13:22:38 -0400
Subject: Re: [PATCH] mtd : add FUJITSU MBM29F800BA and ST M29F800AB
	descriptions
From: David Woodhouse <dwmw2@infradead.org>
To: Philippe De Muyter <phdm@macqel.be>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
In-Reply-To: <20070705150547.GA10281@muff.macqel.be>
References: <20070705150547.GA10281@muff.macqel.be>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 13:23:16 -0400
Message-Id: <1183656196.2756.6.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 17:05 +0200, Philippe De Muyter wrote:
> Add descriptions for Fujitsu MBM29F800BA and ST M29F800AB flash chips.
> Those chips are compatible (except for the ids) with the AMD
> AM29F800BB.

Aren't these CFI-compliant?

-- 
dwmw2

