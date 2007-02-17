Return-Path: <linux-kernel-owner+w=401wt.eu-S1946636AbXBQKqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946636AbXBQKqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946637AbXBQKqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:46:44 -0500
Received: from main.gmane.org ([80.91.229.2]:47633 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946636AbXBQKqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:46:43 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: RE: GPL vs non-GPL device drivers
Date: Sat, 17 Feb 2007 11:46:15 +0100
Message-ID: <er6mdq$ti8$1@sea.gmane.org>
References: <161717d50702160912x6dc4efbahcfb02f665ae3ec8a@mail.gmail.com> <MDEHLPKNGKAHNMBLJOLKIEIMBKAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-221-54-78.cust-adsl.tiscali.it
User-Agent: KNode/0.10.4
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 03:42, David Schwartz wrote:

> Again, see Lexmark v. Static Controls. If "make a toner cartridge that
works
> with a particular Lexmark printer" is a functional idea, why is "make a
> graphics driver that works with a particular Linux kernel" not? What is
the
> difference you think matters?

That you cannot build such modules without integrating parts of actual Linux
kernel code (via #includes etc), whereas you can build compatible toner
cartridges without using any original component.

-- 
Giuseppe "Oblomov" Bilotta

