Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYKPU3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYKPU3A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 15:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYKPU2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 15:28:51 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3144 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYKPU2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 15:28:51 -0500
Date: Sun, 16 Nov 2008 15:27:25 -0500
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Greg KH <greg@kroah.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: [stable] Suspend regression in stable kernel 2.6.27.4 on Mac mini Core Duo
Message-ID: <20081116202725.GA16207@hash.localnet>
References: <20081109202830.GA7206@x61> <20081113192656.GA5735@dose.home.local> <200811132318.13821.rjw@sisk.pl> <200811160004.17804.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811160004.17804.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2008 at 12:04:16AM +0100, Rafael J. Wysocki wrote:
> On Thursday, 13 of November 2008, Rafael J. Wysocki wrote:
> > On Thursday, 13 of November 2008, Tino Keitel wrote:
> 
> This patch also applies to current -stable, so you can test it on top of that.
> 
> I need your confirmation that the patch works to push it upstream.

I can at least confirm the Macbook side of this works fine.  
 
-- 
Bob Copeland %% www.bobcopeland.com

