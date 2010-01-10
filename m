Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556Ab0AJXXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0AJXXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 18:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0AJXXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 18:23:13 -0500
Received: from broadrack.ru ([195.178.208.66]:42768 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab0AJXXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 18:23:12 -0500
Date: Mon, 11 Jan 2010 02:23:06 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #14894] pohmelfs: NULL pointer dereference
Message-ID: <20100110232306.GA16962@ioremap.net>
References: <nzLqtSp97aP.A.RGB.hglSLB@chimera> <CXIfLt-ygXM.A.RRC.4glSLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CXIfLt-ygXM.A.RRC.4glSLB@chimera>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 11:56:17PM +0100, Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14894
> Subject		: pohmelfs: NULL pointer dereference
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2009-12-02 1:11 (40 days old)
> References	: http://marc.info/?l=linux-kernel&m=125971633107940&w=4
> Handled-By	: Evgeniy Polyakov <zbr@ioremap.net>

There is a patch to fix the problem, I will test it in a day and push it
upstrem if it is ok.

-- 
	Evgeniy Polyakov
