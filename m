Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXCNS2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXCNS2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 14:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932325AbXCNS2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 14:28:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:1789 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbXCNS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 14:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,285,1170662400"; 
   d="scan'208"; a="196376105:sNHT74546486"
Date: Wed, 14 Mar 2007 11:25:42 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: eliminate useless bay events
Message-Id: <20070314112542.3d28f659.kristen.c.accardi@intel.com>
In-Reply-To: <20070307021649.GA1448@khazad-dum.debian.net>
References: <20070306154046.942b0706.kristen.c.accardi@intel.com>
	<20070307021649.GA1448@khazad-dum.debian.net>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007 23:16:49 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Tue, 06 Mar 2007, Kristen Carlson Accardi wrote:
> > Eliminate bay events on resume if nothing has changed.
> 
> Are these *really* useless?  What if the *contents* of the bay changed?

Humm... good point.  I will play with this some more to solve the bug
I'm trying to fix a different way.

Please ignore the patch.

Kristen
