Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbXINLeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbXINLeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 07:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbXINLdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 07:33:52 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:49729 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbXINLdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 07:33:51 -0400
Date: Fri, 14 Sep 2007 15:33:54 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070914153354.B5586@jurassic.park.msu.ru>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no> <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no> <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no> <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no> <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca> <20070914151401.A5586@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
In-Reply-To: <20070914151401.A5586@jurassic.park.msu.ru>; from ink@jurassic.park.msu.ru on Fri, Sep 14, 2007 at 03:14:01PM +0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 03:14:01PM +0400, Ivan Kokshaysky wrote:
> whippets doesn't look sane either. ;-)
  ^^^^^^^^
It's not me, it's a spellchecker :-) I meant "chipsets" of course, sorry.

Ivan.
