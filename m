Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbYKLVgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbYKLVgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYKLVgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:36:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59728 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYKLVgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:36:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Wed, 12 Nov 2008 22:41:08 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20081109202830.GA7206@x61> <200811120103.55253.rjw@sisk.pl> <20081112073617.GA4996@dose.home.local>
In-Reply-To: <20081112073617.GA4996@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122241.09943.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 12 of November 2008, Tino Keitel wrote:
> On Wed, Nov 12, 2008 at 01:03:54 +0100, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > Also, can you check this patch on top of 2.6.27.4 and see what happens?
> 
> With that patch, resume works (although I used 2.6.27.5 and not
> 2.6.27.5, if that matters).

It shouldn't really matter.

Thanks for testing and please send me the output of dmidecode.
It seems that blacklisting may be the only way to handle your box. :-(

Thanks,
Rafael
