Return-Path: <linux-kernel-owner+w=401wt.eu-S934929AbXLPRGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbXLPRGl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 12:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbXLPRGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 12:06:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42594 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbXLPRGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 12:06:33 -0500
Date: Sun, 16 Dec 2007 09:09:42 -0800
From: Greg KH <gregkh@suse.de>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.10
Message-ID: <20071216170942.GA13434@suse.de>
References: <20071214194952.GA15765@kroah.com> <200712161636.55127.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712161636.55127.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2007 at 04:36:55PM +0100, Christian Borntraeger wrote:
> Am Freitag, 14. Dezember 2007 schrieb Greg Kroah-Hartman:
> > Christian Borntraeger (1):
> >       Future of Linux 2.6.22.y series
> 
> This should be: rd: fix data corruption on memory pressure.
> Same for 2.6.22

Yes, sorry, I messed up and had two "Subject" lines in your patch, and
quilt picked up the second one, which I used for the review, and git
picked up the first one, which I used to apply them to the tree.

thanks,

greg k-h
