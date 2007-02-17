Return-Path: <linux-kernel-owner+w=401wt.eu-S2992868AbXBQXbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992868AbXBQXbM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 18:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992876AbXBQXbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 18:31:12 -0500
Received: from main.gmane.org ([80.91.229.2]:50153 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992868AbXBQXbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 18:31:12 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: RE: GPL vs non-GPL device drivers
Date: Sun, 18 Feb 2007 00:30:46 +0100
Message-ID: <er837a$8ks$1@sea.gmane.org>
References: <er6mdq$ti8$1@sea.gmane.org> <MDEHLPKNGKAHNMBLJOLKKEKKBKAC.davids@webmaster.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: host-84-221-54-212.cust-adsl.tiscali.it
User-Agent: KNode/0.10.4
X-Face: ::w9}R^l{WGM\{y)C0QF@4^U,',W3Mk^X0HP)=:bKM^Z]A9+6bY6fe3}O*]fH{l<j1/9RTp  `KR0idy]Im#9^%}P5Dga'>AViT_'?&>&ufo2_X5Vs3C^tPO@drZRuu&6iK}x}~9`F\-dNZ>(p|V7`4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 15:19, David Schwartz wrote:

> Static Controls argued that taking the TLP was the only practical way to
> make a cartridge that would work with that printer.

Which shows how that case is different from writing Linux drivers. For
example, looking at the example the OP was himself proposing a few
alternative approaches to work around the limitation they were hitting:
could just switch to static major/minors instead of dynamics ones, they
could skip sysfs, or they could even reimplement something like sysfs
themselves, or whatever other interface they deem useful for the purpose of
plopping in their own binary blob on top of it, sort of like what nVidia
and ATi do for their stuff.

-- 
Giuseppe "Oblomov" Bilotta

