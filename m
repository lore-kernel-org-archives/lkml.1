Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbXGWOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbXGWOcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753060AbXGWOcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 10:32:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34156 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbXGWOcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 10:32:05 -0400
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
From: Arjan van de Ven <arjan@infradead.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
References: <200707232305.12364.nigel@nigel.suspend2.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 23 Jul 2007 07:29:55 -0700
Message-Id: <1185200995.2714.58.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 23:05 +1000, Nigel Cunningham wrote:
> Hi all.
> 
> As we all know, pageflags have been a scarce resource for a while now. These 
> patches seek to help address that issue by adding support for a new type 
> of 'dynamically allocated' pageflag.


but... does this really solve it? I mean.. you can still run out... so
then what?


