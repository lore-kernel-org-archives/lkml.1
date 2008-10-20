Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYJTDuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYJTDuk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbYJTDuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:50:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYJTDuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:50:22 -0400
Date: Sun, 19 Oct 2008 20:50:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Make initcall_debug a core_param
Message-ID: <20081019205031.31d00e8e@infradead.org>
In-Reply-To: <200810201420.25510.rusty@rustcorp.com.au>
References: <200810201420.25510.rusty@rustcorp.com.au>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Oct 2008 22:20:25 -0500
Rusty Russell <rusty@rustcorp.com.au> wrote:

> 
> This is the one I really wanted: now it effects module loading, it
> makes sense to be able to flip it after boot.

makes total sense to me

Acked-by: Arjan van de Ven <arjan@linux.intel.com>


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
