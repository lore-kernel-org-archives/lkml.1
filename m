Return-Path: <linux-kernel-owner+w=401wt.eu-S932238AbXBSOBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238AbXBSOBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932255AbXBSOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:01:48 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:43842 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbXBSOBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:01:47 -0500
Subject: Re: [PATCH 09/44 take 2] [UBI] debug unit header
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: dedekind@infradead.org
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1171888399.13817.21.camel@sauron>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain>
	 <20070217165509.5845.12977.sendpatchset@localhost.localdomain>
	 <200702172218.22709.arnd@arndb.de>  <1171888399.13817.21.camel@sauron>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 08:02:49 -0600
Message-Id: <1171893769.24204.15.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 14:33 +0200, Artem Bityutskiy wrote:
> On Sat, 2007-02-17 at 22:18 +0100, Arnd Bergmann wrote:
> > If you feel that Linux needs rich debugging capabilities, then submit
> > a patch for that independent of UBI.
> 
> I will fix the comment which annoys.

It is not the comment that annoys people.  Arnd was saying that the
entire debug unit should not exist.

josh

