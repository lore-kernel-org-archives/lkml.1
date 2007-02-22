Return-Path: <linux-kernel-owner+w=401wt.eu-S1751468AbXBVIPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbXBVIPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 03:15:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbXBVIPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 03:15:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58646 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbXBVIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 03:15:08 -0500
Subject: Re: -freg-struct-return?
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45DD4FA0.5030205@goop.org>
References: <45DCF1C5.4030006@goop.org>
	 <1172131463.3531.226.camel@laptopd505.fenrus.org>
	 <45DD4FA0.5030205@goop.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 09:15:03 +0100
Message-Id: <1172132103.3531.228.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Do we have much assembler which cares about the struct return calling
> convention?  If not, it should be a fairly easy test.

is there an attribute to turn it off? because if so we should just make
that part of "asmlinkage".... (not that I know much code using structs
in asm)
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

