Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbZAHQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbZAHQ6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbZAHQ6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:58:05 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58541
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754760AbZAHQ6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:58:04 -0500
Date: Thu, 08 Jan 2009 08:58:06 -0800 (PST)
Message-Id: <20090108.085806.43922610.davem@davemloft.net>
To: gregkh@suse.de
Cc: heiko.carstens@de.ibm.com, torvalds@linux-foundation.org,
       inaky@linux.intel.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: fix compile bug
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090108165254.GA13737@suse.de>
References: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
	<20090108165254.GA13737@suse.de>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@suse.de>
Date: Thu, 8 Jan 2009 08:52:54 -0800

> On Thu, Jan 08, 2009 at 05:12:22PM +0100, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > wimax should depend on INPUT:
> 
> <snip>
> 
> Inaky just sent a series of 3 patches to the netdev mailing list fixing
> this up in a much better way.

Yep, I'll be integrating his patches during the course of
today.
