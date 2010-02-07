Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0BGOgo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 09:36:44 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:38445 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0BGOgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 09:36:43 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: BUG: Bad page state in process portageq
Date: Sun, 7 Feb 2010 15:36:36 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc6-00228-g56dca4c; KDE/4.3.98; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201002070145.47514.johannes.hirte@fem.tu-ilmenau.de> <20100207132331.GA4138@x200>
In-Reply-To: <20100207132331.GA4138@x200>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002071536.37512.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 07 Februar 2010 14:23:31 schrieb Alexey Dobriyan:
> On Sun, Feb 07, 2010 at 01:45:46AM +0100, Johannes Hirte wrote:
> > Feb  6 20:47:45 datengrab kernel: BUG: Bad page state in process portageq
> > pfn:2846d
> 
> Run memtest.

Sorry forgot to mention, the machine is with ECC RAM equipped. So if there are 
any memory errors, shouldn't I find something in the logs, either BIOS or by 
the edac driver?

regards,
  Johannes
