Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbYJVGus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbYJVGus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 02:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYJVGuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 02:50:25 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42244 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYJVGuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 02:50:24 -0400
Date: Wed, 22 Oct 2008 08:50:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: benh@kernel.crashing.org
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/7] i2c: add info->archdata field
Message-ID: <20081022085002.0698e2a8@hyperion.delvare>
In-Reply-To: <1224635254.7654.292.camel@pasglop>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	<20081016171253.GB5515@oksana.dev.rtsoft.ru>
	<20081017112125.1f2c9d94@hyperion.delvare>
	<1224635254.7654.292.camel@pasglop>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 11:27:34 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2008-10-17 at 11:21 +0200, Jean Delvare wrote:
> > Hi Anton,
> > 
> > On Thu, 16 Oct 2008 21:12:53 +0400, Anton Vorontsov wrote:
> > > If present the info->archdata is copied into the dev->archdata.
> > > Some (OpenFirmware) platforms need it.
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > > ---
> 
> So who's pushing this one ? Jean ?

As I wrote before, I'm happy to take this patch if you want me to, but
I also have no objection if the author of this patchset wants to push
it himself together with the rest of the set. Just let me know what you
expect from me (preferably in the next few hours, as I will be sending
my second and last round of i2c patches for kernel 2.6.28 to Linus
today.)

-- 
Jean Delvare
