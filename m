Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYFJPLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYFJPLn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 11:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYFJPLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 11:11:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:39695 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbYFJPLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 11:11:35 -0400
Date: Tue, 10 Jun 2008 07:24:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 01/21] perfmon2 minimal:  generic hooks
Message-ID: <20080610072451.76666741@infradead.org>
In-Reply-To: <484dafc0.0af6660a.55fa.617b@mx.google.com>
References: <484dafc0.0af6660a.55fa.617b@mx.google.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Jun 2008 15:33:36 -0700 (PDT)
eranian@googlemail.com wrote:

> This simple patch adds the perfmon subdirectory to the
> top-level Makefile.

doesn't doing this first make this patch series unbisectable?

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
