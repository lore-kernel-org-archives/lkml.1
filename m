Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbXF0JMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbXF0JMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 05:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752244AbXF0JMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 05:12:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:42687 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750958AbXF0JMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 05:12:31 -0400
X-Authenticated: #1474915
X-Provags-ID: V01U2FsdGVkX19qbFJOwKNqGFaEz/wNrtYQua6R/dmECF5//9JMU0
	ZRDUl/GmuVViUm
Message-ID: <468229FA.4040207@gmx.de>
Date: Wed, 27 Jun 2007 11:12:26 +0200
From: Thomas Sattler <tsattler@gmx.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: BUG: held lock freed!
References: <4680EAB8.10703@gmx.de> <Pine.LNX.4.64.0706261557320.30082@blonde.wat.veritas.com> <4681524F.9090608@gmx.de>
In-Reply-To: <4681524F.9090608@gmx.de>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll run memtest86+ this night and post the results tomorrow.

Memtest86+ did not show any problems:

time   8h
pass   24
errors  0

Please remember to CC me as I'm not subscribed to the list.

Thomas

-- 
keep mailinglists in english, feel free to send PM in german
