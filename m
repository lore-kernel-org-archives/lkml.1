Return-Path: <linux-kernel-owner+w=401wt.eu-S1755590AbYCKJd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbYCKJd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYCKJdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:33:19 -0400
Received: from mail.suse.de ([195.135.220.2]:55754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbYCKJdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:33:18 -0400
From: Andreas Schwab <schwab@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avi Kivity <avi@qumranet.com>, Sam Ravnborg <sam@ravnborg.org>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>,
       linux-arch@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: [PATCH] kvm: provide kvm.h for all architecture: fixes headers_install
References: <200803071326.06682.borntraeger@de.ibm.com>
	<20080310232039.d2a34f5a.akpm@linux-foundation.org>
	<1205217745.2592.86.camel@shinybook.infradead.org>
	<200803110810.49759.borntraeger@de.ibm.com>
X-Yow: Three attractive BANK ROBBERS are discussing RELIGIOUS DIFFERENCES and
 MAKE-UP TECHNIQUE with them!!
Date: Tue, 11 Mar 2008 10:33:15 +0100
In-Reply-To: <200803110810.49759.borntraeger@de.ibm.com> (Christian
	Borntraeger's message of "Tue\, 11 Mar 2008 08\:10\:49 +0100")
Message-ID: <je7ig9hag4.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Borntraeger <borntraeger@de.ibm.com> writes:

>  include/asm-alpha/kvm.h        |    6 ++++++

Can't you put it in asm-generic?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
