Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125AbZGJOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbZGJOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbZGJOCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 10:02:12 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4788 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbZGJOCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 10:02:10 -0400
X-IronPort-AV: E=Sophos;i="4.42,378,1243828800"; 
   d="scan'208";a="57943495"
Subject: Re: [PATCH 00/11] swiotlb: Introduce architecture-specific APIs to
	replace __weak functions (v2)
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Kumar Gala <galak@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Tony Luck <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <x86@kernel.org>
In-Reply-To: <1247205356.15530.18.camel@pasglop>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
	 <1247205356.15530.18.camel@pasglop>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 10 Jul 2009 15:02:07 +0100
Message-ID: <1247234527.4002.420.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 15:55 +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-01 at 16:32 +0100, Ian Campbell wrote:
> > This series:[...]

> Looks like I was only CCed on part of them... it's not very handy for me
> as I end up having some of the patches in one folder and some
> elsewhere :-)

Sorry about that -- I was concerned about spamming the world and his dog
with patches which didn't directly interest them. For any future series
of this type I'll CC everyone on everything.

Ian.


