Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbZEVIzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbZEVIzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZEVIz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:55:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:11773 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbZEVIz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:55:26 -0400
X-IronPort-AV: E=Sophos;i="4.41,232,1241409600"; 
   d="scan'208";a="4393333"
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Becky Bruce <beckyb@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       xen-devel <xendevel@lists.xensource.com>,
       x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       Tony Breeds <tony@bakeyournoodle.com>
In-Reply-To: <4A1585AA.9010002@oracle.com>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
	 <4A1585AA.9010002@oracle.com>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 09:55:24 +0100
Message-ID: <1242982524.22654.218.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-21 at 12:47 -0400, Randy Dunlap wrote:
> Try these.  They are fairly current.  I have used several of them.
> 
> http://bakeyournoodle.com/cross/

Thanks for the pointer, these look ideal.

Ian.


