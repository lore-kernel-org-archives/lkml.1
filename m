Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbYLHL0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbYLHL0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:26:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYLHL0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:26:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37288 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYLHL0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:26:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Date: Mon, 8 Dec 2008 12:25:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Bob Copeland <me@bobcopeland.com>
References: <20081109202830.GA7206@x61> <200811160004.17804.rjw@sisk.pl> <20081208075531.GA20779@dose.home.local>
In-Reply-To: <20081208075531.GA20779@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812081225.44832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Tino Keitel wrote:
> On Sun, Nov 16, 2008 at 00:04:16 +0100, Rafael J. Wysocki wrote:
> > On Thursday, 13 of November 2008, Rafael J. Wysocki wrote:
> 
> [...]
> 
> > > Please try the appended patch on top of the Linus' tree.
> > 
> > This patch also applies to current -stable, so you can test it on top of that.
> > 
> > I need your confirmation that the patch works to push it upstream.
> 
> Hi,
> 
> I saw that 2.6.27.8 still missed that fix, maybe because I forgot to
> send any confirmation. So, yes, this patch fixes the regression for me.

Thanks.

I sent the inclusion request to -stable, but apparently it was too late for
2.6.27.8.

Rafael
