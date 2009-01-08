Return-Path: <linux-kernel-owner+w=401wt.eu-S1761262AbZAHQye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761262AbZAHQye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZAHQyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:54:09 -0500
Received: from ns1.suse.de ([195.135.220.2]:53870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761127AbZAHQyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:54:08 -0500
Date: Thu, 8 Jan 2009 08:52:54 -0800
From: Greg KH <gregkh@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax: fix compile bug
Message-ID: <20090108165254.GA13737@suse.de>
References: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090108161222.GC4821@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2009 at 05:12:22PM +0100, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> wimax should depend on INPUT:

<snip>

Inaky just sent a series of 3 patches to the netdev mailing list fixing
this up in a much better way.

thanks,

greg k-h
