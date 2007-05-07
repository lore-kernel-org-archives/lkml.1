Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbXEGBw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbXEGBw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbXEGBw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:52:26 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61749 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbXEGBw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:52:26 -0400
Date: Sun, 6 May 2007 18:55:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: regressions
Message-Id: <20070506185556.85cb602c.randy.dunlap@oracle.com>
In-Reply-To: <200705062049.l46KnD424997@apps.cwi.nl>
References: <200705062049.l46KnD424997@apps.cwi.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 May 2007 22:49:13 +0200 (MEST) Andries.Brouwer@cwi.nl wrote:

> 2.6.21 breaks HPT366 - back to 2.6.20
> 2.6.20 breaks ZIP - back to 2.6.19
> 2.6.19 seems OK at first sight
> 
> [more info on request, this is well-known?]

ZIP as in ZIP drive(r)?  imm/ppa or IDE?
imm breakage was reported and is fixed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
