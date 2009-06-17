Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZFQEGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZFQEGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZFQEGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:06:11 -0400
Received: from gate.crashing.org ([63.228.1.57]:44527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbZFQEGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:06:10 -0400
Subject: Re: [PATCH] driver/core: Fix various warnings due to
 dev_set_name() usage
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090617025134.GA6807@kroah.com>
References: <1245203150.21602.10.camel@pasglop>
	 <20090617025134.GA6807@kroah.com>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 14:06:04 +1000
Message-Id: <1245211564.21602.19.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-16 at 19:51 -0700, Greg KH wrote:
> 
> These have all been fixed in linux-next for a while, and are already
> contained in the patchset I sent to Linus for inclusion in his tree
> yesterday.
> 
> But thanks anyway :)

Argh, oh well ... I should have waited one more day :-)

Cheers,
Ben.


