Return-Path: <linux-kernel-owner+w=401wt.eu-S1946037AbXBCP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946037AbXBCP0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946299AbXBCP0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:26:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44575 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946037AbXBCP0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:26:19 -0500
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
	release.
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45C362D2.2040407@tmr.com>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
	 <45C362D2.2040407@tmr.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sat, 03 Feb 2007 16:26:16 +0100
Message-Id: <1170516376.3073.1015.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Because user threading can avoid context switches, there will always be 
> cases where it will outperform o/s threads for hardware reasons.

actually.. switching from one "real" thread to another in Linux is not
an actual context switch in the hardware sense... at least this part of
your argument seems to be incorrect ;)

> 
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

