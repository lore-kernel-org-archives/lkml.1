Return-Path: <linux-kernel-owner+w=401wt.eu-S1945958AbXBVKfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945958AbXBVKfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945964AbXBVKfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:35:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52125 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945958AbXBVKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:35:10 -0500
Subject: RE: [kvm-devel] [PATCH 10/13] KVM: Wire up hypercall handlers to a
	central arch-independent location
From: Arjan van de Ven <arjan@infradead.org>
To: Dor Laor <dor.laor@qumranet.com>
Cc: Avi Kivity <avi@qumranet.com>, Pavel Machek <pavel@ucw.cz>,
       kvm-devel@lists.sourceforge.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
References: <45D979D3.2020907@qumranet.com>
	 <20070219103052.4D23725016B@il.qumranet.com><20070221103733.GI3945@ucw.cz>
	 <45DD6CF0.3010509@qumranet.com>
	 <64F9B87B6B770947A9F8391472E032160A91BAF3@ehost011-8.exch011.intermedia.net>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 11:34:50 +0100
Message-Id: <1172140490.3531.236.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> >
> 
> I have Ingo's network PV hypercalls to commit in my piplien.

I have 5 or so pending as well :)
can't wait for the infrastructure to be there so that it's relatively
easy to add my paravirt block driver

