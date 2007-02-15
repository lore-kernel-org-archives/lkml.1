Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbXBOVxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbXBOVxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXBOVxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:53:32 -0500
Received: from ns.firmix.at ([62.141.48.66]:42211 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbXBOVxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:53:31 -0500
Subject: Re: GPL vs non-GPL device drivers
From: Bernd Petrovitsch <bernd@firmix.at>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Ben Nizette <ben.nizette@iinet.net.au>, v j <vj.linux@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45D40E81.3050506@yahoo.com.au>
References: <9b3a62ab0702142115m4ea7d2c0m6869eb64ef3ee14e@mail.gmail.com>
	 <9b3a62ab0702142116n4069e16cl1bc8f546f41d935@mail.gmail.com>
	 <45D3FC67.3000903@iinet.net.au>  <45D40E81.3050506@yahoo.com.au>
Content-Type: text/plain
Organization: http://www.firmix.at/
Date: Thu, 15 Feb 2007 22:53:17 +0100
Message-Id: <1171576397.3473.10.camel@gimli.at.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
X-Firmix-Spam-Status: No, hits=-2.416 required=5
X-Spam-Score: -2.416 () AWL,BAYES_00,FORGED_RCVD_HELO
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-15 at 18:40 +1100, Nick Piggin wrote:
> Ben Nizette wrote:
[...]
> > Question to the world here:  Distros make, as a matter of course, a 
> > series of modifications to the Linux Kernel so that their modules or 
> > features work.  What stops VJ making a patchset which effectively 
> > s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/g 's the kernel source then 
> > distributing that under the GPL?  He then supplies his un-GPL'd modules 

Nothing. But it is pointless since that doesn't un-GPL source code.

[...]
> Rhetorical question: what stops me from taking somebody's copyrighted
> work, stripping the copyrights or falsely claiming to have a license
> to redistribute it, then selling it?

No one.
But that doesn't make the action legal or change the copyright/authors
rights in anyway (at least in the more civilized parts of the world).

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services

