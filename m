Return-Path: <linux-kernel-owner+w=401wt.eu-S1761782AbXIMQch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761782AbXIMQch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbXIMQca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:32:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXIMQc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:32:29 -0400
Date: Thu, 13 Sep 2007 12:31:56 -0400
From: Alan Cox <alan@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org,
       Tony Breeds <tony@bakeyournoodle.com>,
       Michael Neuling <mikey@neuling.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Alan Cox <alan@redhat.com>,
       davem@davemloft.net, heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       dhowells@redhat.com
Subject: Re: Define termios_1 functions for powerpc, s390, avr32 and frv
Message-ID: <20070913163156.GA29118@devserv.devel.redhat.com>
References: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18152.719.316280.579601@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:16:31AM +1000, Paul Mackerras wrote:
> asm-generic/termios.h).
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Acked-by: Alan Cox <alan@redhat.com>
