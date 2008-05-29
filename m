Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbYE2WdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbYE2WdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 18:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYE2WdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 18:33:10 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55651 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbYE2WdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 18:33:08 -0400
Date: Thu, 29 May 2008 23:32:49 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Matthew Garrett <mjg@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Message-ID: <20080529223249.GA1051@srcf.ucam.org>
References: <20080529212110.GA2870@suse.de> <200805292327.45561.laurent.pinchart@skynet.be> <20080529214706.GA3277@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080529214706.GA3277@suse.de>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [GIT PATCH] USB fixes for 2.6.26-rc4
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 02:47:06PM -0700, Greg KH wrote:

> But until then, the easiest way to get this hardware working for users
> is a tiny kernel firmware loader just like this one.  If you think we
> should turn it into something for all ezusb devices, that's also a
> possiblity.

I'd certainly have no objection to making it generic, but this is the 
only EZ-USB hardware I have to hand. Right now I've just ended up 
irritated that we don't have any sort of consistent solution to dealing 
with this, and I'd like these webcams to work.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
