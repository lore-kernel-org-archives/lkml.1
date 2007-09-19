Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbXISQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbXISQzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbXISQzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:55:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51309 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbXISQzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:55:36 -0400
Date: Wed, 19 Sep 2007 17:55:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, David Wilder <dwilder@us.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [Patch 1/2] Trace code and documentation (updated)
Message-ID: <20070919165507.GA18973@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	David Wilder <dwilder@us.ibm.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1190177218.3190.18.camel@lc4eb748232119.ibm.com> <p736427vz00.fsf@bingen.suse.de> <46F12ED7.3060605@us.ibm.com> <20070919162018.GA16237@infradead.org> <20070919095223.83bd8226.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919095223.83bd8226.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 09:52:23AM -0700, Randy Dunlap wrote:
> That's why they exmaples should not be hidden/embedded in .txt files;
> they should be standalone .c files with makefiles etc.

Yes.  And most importantly integrated with the kernel build system.

> and they can be taken out of Documentation/ whenever they go into
> util-linux-ng or elsewhere.  Let's get the order correct.

Well, this is kernel code - so util-linux is not the solution here
obviously :)

