Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYJ3X4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYJ3X4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYJ3X4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:56:04 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58350 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYJ3X4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:56:02 -0400
Date: Thu, 30 Oct 2008 16:55:32 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       gregkh <greg@kroah.com>
Subject: Re: linux-next: Tree for October 30
Message-Id: <20081030165532.802375f8.randy.dunlap@oracle.com>
In-Reply-To: <20081030173030.d8847df6.sfr@canb.auug.org.au>
References: <20081030173030.d8847df6.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 17:30:30 +1100 Stephen Rothwell wrote:


Greg told me that he would fix these, but they are still around:

drivers/staging/poch/poch.c:388: warning: format '%x' expects type 'unsigned int', but argument 4 has type 'dma_addr_t'

drivers/usb/misc/vstusb.c:623: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'


Otherwise it's a quiet randconfig tree.  Must be short of new commits.  ;)

---
~Randy
