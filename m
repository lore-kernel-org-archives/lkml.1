Return-Path: <linux-kernel-owner+w=401wt.eu-S1760450AbYDOLIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450AbYDOLIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 07:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756053AbYDOLIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 07:08:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755969AbYDOLII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 07:08:08 -0400
Date: Tue, 15 Apr 2008 07:07:45 -0400
From: Alan Cox <alan@redhat.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       alan@redhat.com, borntraeger@de.ibm.com, peter.oberparleiter@de.ibm.com,
       schwidefsky@de.ibm.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + s390-tty-prepare-for-put_char-to-return-success-fail.patch added to -mm tree
Message-ID: <20080415110745.GA11858@devserv.devel.redhat.com>
References: <200804150204.m3F24GdU005600@imap1.linux-foundation.org> <20080415072117.GA4177@osiris.boeblingen.de.ibm.com> <20080415111101.41b6e9e3@core> <20080415104507.GA18307@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080415104507.GA18307@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 12:45:07PM +0200, Heiko Carstens wrote:
> Ok, thanks for pointing this out! We are going to fix this as soon as your
> patch is merged, so we can avoid further merge conflicts.
> I assume your patch is for 2.6.26?

I would hope so - assuming no other bugs fall out of this.

Alan

