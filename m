Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZDEPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZDEPRS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZDEPRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 11:17:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:34995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbZDEPRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 11:17:03 -0400
Date: Sun, 5 Apr 2009 08:18:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Intepreting an oops
Message-ID: <20090405081839.080150fc@infradead.org>
In-Reply-To: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
References: <COL116-W68F0521CACD2E1656E8D1BDA870@phx.gbl>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Apr 2009 14:48:19 +0200
Peter Hallberg <hallberg68@hotmail.com> wrote:

> 
> How does one translate the offset in the function to a line number in
> the source code? 

you take the whole oops and use the scripts/markup_oops.pl script
to pipe it through.. and it gives you this information quite nicely.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
