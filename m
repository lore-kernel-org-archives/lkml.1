Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbXIRVgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbXIRVgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbXIRVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:36:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:47515 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbXIRVgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:36:05 -0400
Subject: Re: 2.6.23-rc6-mm1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070918191630.GB11083@kroah.com>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <46EF96CC.1080807@linux.vnet.ibm.com> <20070918093444.GB973@shadowen.org>
	 <1190109772.6403.79.camel@localhost.localdomain>
	 <46EFBF9E.6060208@linux.vnet.ibm.com>  <20070918191630.GB11083@kroah.com>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 07:35:32 +1000
Message-Id: <1190151332.6403.109.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-18 at 12:16 -0700, Greg KH wrote:
> Oh, and sorry for breaking this, I could only test all of the modules
> build on x86 due to traveling while creating this patch.  I need to
> set
> up some cross-compilers on my laptop to fix this issue :( 

Yuck :-) Oh well, I hope you have a _FAST_ laptop :-)

Cheers,
Ben.


