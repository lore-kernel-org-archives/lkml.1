Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbXFWQmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbXFWQmX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 12:42:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXFWQmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 12:42:16 -0400
Received: from verein.lst.de ([213.95.11.210]:47989 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762AbXFWQmP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 12:42:15 -0400
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: Grozdan Nikolov <microchip@chello.be>
Subject: Re: How innovative is Linux?
Date: Sat, 23 Jun 2007 18:42:00 +0200
User-Agent: KMail/1.9.7
References: <200706231417.16086.microchip@chello.be> <200706231812.02317.duwe@lst.de> <200706231819.43556.microchip@chello.be>
In-Reply-To: <200706231819.43556.microchip@chello.be>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706231842.00798.duwe@lst.de>
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 June 2007, you wrote:

> hmm, wasn't loadable kernel modules first implemented in SunOS 4.x [...]
Yes, but that was pretty cumbersome. You had to resolve the symbols in user 
space, using a hopefully matching /vmunix. Linux was first to feature an 
in-kernel linker and symbol table, IIRC.

	Torsten
