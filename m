Return-Path: <linux-kernel-owner+w=401wt.eu-S1758795AbXFSNVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758795AbXFSNVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756387AbXFSNVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:21:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60595 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbXFSNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:21:11 -0400
Subject: Re: Dumping the checksums in a module
From: Arjan van de Ven <arjan@infradead.org>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4677C539.7020203@free.fr>
References: <4677C539.7020203@free.fr>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 19 Jun 2007 06:18:04 -0700
Message-Id: <1182259085.3014.5.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 13:59 +0200, John Sigler wrote:
> Hello everyone,
> 
> As far as I understand (which is not very far), if I define
> CONFIG_MODVERSIONS,


just don't enable modversions.. it doesn't provide you any real safety
at all..... and it makes your build a LOT slower.


