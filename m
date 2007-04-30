Return-Path: <linux-kernel-owner+w=401wt.eu-S1423238AbXD3NQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423238AbXD3NQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 09:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423251AbXD3NQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 09:16:09 -0400
Received: from bill.weihenstephan.org ([82.135.35.21]:56283 "EHLO
	bill.weihenstephan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423238AbXD3NQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 09:16:07 -0400
From: Juergen Beisert <juergen127@kreuzholzen.de>
Organization: Privat
To: linux-kernel@vger.kernel.org
Subject: Re: Geode-GX1 processor in 2.6.21
Date: Mon, 30 Apr 2007 15:16:05 +0200
User-Agent: KMail/1.9.4
Cc: Andreas Mohr <andi@rhlx01.fht-esslingen.de>
References: <200704301251.05697.juergen127@kreuzholzen.de> <20070430122022.GA9896@rhlx01.hs-esslingen.de>
In-Reply-To: <20070430122022.GA9896@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704301516.05611.juergen127@kreuzholzen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 April 2007 14:20, Andreas Mohr wrote:
> Also, it would probably be good to convert these macros into inline
> functions in this header.

I tried with inlined functions and it works now as expected. I sent a patch, 
maybe it helps others too.

Juergen
