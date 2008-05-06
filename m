Return-Path: <linux-kernel-owner+w=401wt.eu-S1762526AbYEFQ3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762526AbYEFQ3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762271AbYEFQ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:28:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbYEFQ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:28:49 -0400
Date: Tue, 6 May 2008 12:20:00 -0400
From: Alan Cox <alan@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Alan Cox <alan@redhat.com>,
       Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 7/8] tty3270: fix put_char fail/success conversion.
Message-ID: <20080506162000.GA25382@devserv.devel.redhat.com>
References: <20080506155027.974409738@de.ibm.com> <20080506155112.537584495@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506155112.537584495@de.ibm.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 05:50:34PM +0200, Martin Schwidefsky wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>  The wrong function got coverted ;)

Hehe.. 

> Cc: Alan Cox <alan@redhat.com>
> Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

Acked-by: Alan Cox <alan@redhat.com>
