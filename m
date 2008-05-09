Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYEIIja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYEIIja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 04:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbYEIIjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 04:39:16 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50518 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbYEIIjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 04:39:14 -0400
Date: Fri, 9 May 2008 10:39:12 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [ASYNC_TX] don't include <asm/> headers
Message-ID: <20080509083912.GA32396@Chamillionaire.breakpoint.cc>
References: <20080426154801.GA18712@Chamillionaire.breakpoint.cc> <e9c3a7c20804292342o38ca485by4dec2d137fefcac5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <e9c3a7c20804292342o38ca485by4dec2d137fefcac5@mail.gmail.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dan Williams | 2008-04-29 23:42:46 [-0700]:

>Thanks, I'll push this out for testing in -next / -mm.
I can't see this in current -next and I can't remember that I got an
email from Andrew.

>
>--
>Dan

Sebastian
