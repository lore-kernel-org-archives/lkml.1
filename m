Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXGKJlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXGKJlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762143AbXGKJlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:41:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762125AbXGKJk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:40:59 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: -mm merge plans for 2.6.23 -- sys_fallocate
Date: Wed, 11 Jul 2007 11:40:50 +0200
User-Agent: KMail/1.9.6
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710180531.GB8908@osiris.ibm.com> <20070710114119.d8e874a1.akpm@linux-foundation.org>
In-Reply-To: <20070710114119.d8e874a1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707111140.50933.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I'd support an ununofficial rule that submitters of new syscalls also raise
> a patch against LTP, come to that...

And a patch for the manpages. Definitely in favor. 

-Andi
