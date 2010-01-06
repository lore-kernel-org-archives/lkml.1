Return-Path: <linux-kernel-owner+w=401wt.eu-S932461Ab0AFRcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab0AFRcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 12:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932395Ab0AFRca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 12:32:30 -0500
Received: from www84.your-server.de ([213.133.104.84]:36460 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0AFRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 12:32:30 -0500
Subject: Re: [PATCH] enhanced reimplemented of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: tytso@mit.edu
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100106170355.GB24604@thunk.org>
References: <1262776358.29513.10.camel@wall-e>
	 <20100106170355.GB24604@thunk.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 06 Jan 2010 18:32:05 +0100
Message-ID: <1262799125.2214.5.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.01.2010, 12:03 -0500 schrieb tytso@mit.edu:
> On Wed, Jan 06, 2010 at 12:12:38PM +0100, Stefani Seibold wrote:
> > - Smaller footprint
> 
> Have you measured how much smaller a full built kernel ends up being
> with this patch?
> 

I compared it which some modules. It is not extremely significant, only
some bytes. But if you use real in place then you would get better
results. I will send some values. Stay tuned ;-) 

> > The patch-set is against linux 2.6.33-rc2. This code is ready to merge :-)
> > Please do!
> 
> You weren't seriously suggesting merging such a large patch post -rc3,
> were you?  I assume you were requesting this be queued up for the next
> merge window, right?

Right, not for 2.6.33. I asked for 2.6.34.

Stefani


