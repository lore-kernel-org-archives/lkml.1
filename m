Return-Path: <linux-kernel-owner+w=401wt.eu-S1755582AbXHUJWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbXHUJWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 05:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753466AbXHUJWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 05:22:30 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:53976 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbXHUJW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 05:22:29 -0400
Date: Tue, 21 Aug 2007 02:21:46 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: perfmon@napali.hpl.hp.com
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       akpm@linux-foundation.org, ak@suse.de
Subject: Re: [perfmon] perfmon2 kernel: git tree up and running
Message-ID: <20070821092146.GB11173@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070820131605.GE8667@frankl.hpl.hp.com> <16D5B9AB904B0B46B22A27002EE3A8C8C9712C@scsmsx415.amr.corp.intel.com> <46C9D90B.3040001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C9D90B.3040001@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have found the source of the problem for the tree not showing
up at http://git.kernel.org. The tree top dir needs to have the
.git suffix. I fixed that now and you can now browse the code online.

I am sorry about the inconvenience but I was not aware of the
restriction.

Anyway, to get a of copy of the perfmon2 kernel tree:

	git clone git://git.kernel.org/pub/scm/linux/kernel/git/eranian/linux-2.6.git

Thanks.

--
-Stephane
