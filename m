Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYICLmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYICLmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 07:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYICLmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 07:42:43 -0400
Received: from ns.firmix.at ([62.141.48.66]:2073 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbYICLmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 07:42:42 -0400
Subject: RE: Request: Remove duplicate file names in the kernel source
From: Bernd Petrovitsch <bernd@firmix.at>
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <BLU122-W53394124DC17062A5A86FDDA5E0@phx.gbl>
References: <BLU122-W542897329D9AB74E77D73DA5F0@phx.gbl>
	 <alpine.LFD.1.10.0809030123220.3243@apollo.tec.linutronix.de>
	 <BLU122-W53394124DC17062A5A86FDDA5E0@phx.gbl>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 03 Sep 2008 13:42:14 +0200
Message-Id: <1220442134.16852.7.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.345 required=5
X-Spam-Score: -2.345 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-03 at 13:22 +0200, Peter Hallberg wrote:
> 
> > # include\linux\netfilter\xt_connmark.h: No such file or directory
> >
> > Nothing to fix here.
> 
> That file do exist so you are doing something wrong.

Why don't you simply install CygWin (and use it to study the kernel
sources) which solves your problem?
Otherwise the next "request" is perhaps to rename all files to 8+3 so
that people on pure MSDOS-6.22 can study the kernel sources.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


