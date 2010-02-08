Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107Ab0BHLkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 06:40:53 -0500
Received: from smtp.nokia.com ([192.100.122.230]:40826 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab0BHLkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 06:40:51 -0500
Subject: Re: linux-next: manual merge of the omap_dss2 tree with the omap
 tree
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: ext Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tony Lindgren <tony@atomide.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vaibhav Hiremath <hvaibhav@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <20100208215715.c78b2a9c.sfr@canb.auug.org.au>
References: <20100208172521.abb500b4.sfr@canb.auug.org.au>
	 <1265621346.2433.27.camel@tubuntu.research.nokia.com>
	 <20100208215715.c78b2a9c.sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia
Date: Mon, 08 Feb 2010 13:43:05 +0200
Message-ID: <1265629385.2433.29.camel@tubuntu.research.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Feb 2010 11:40:21.0936 (UTC) FILETIME=[7F271300:01CAA8B3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-02-08 at 11:57 +0100, ext Stephen Rothwell wrote:
> Hi Tomi,
> 
> On Mon, 08 Feb 2010 11:29:06 +0200 Tomi Valkeinen <tomi.valkeinen@nokia.com> wrote:
> >
> > > P.S. Tomi, this omap_dss2 commit only has your Acked-by not Signed-off-by.
> > 
> > Hmm, do you mean there's something wrong with that, or "jfyi"? Aren't I,
> > as a subsys maintainer, supposed to ack the patches?
> 
> If a patch goes through your tree, you are supposed to add a Signed-off-by
> line.  See Documentation/SubmittingPatches section called "Sign your
> work".

So it is. Thanks for pointing this out, I'll change the acks to
signed-offs.

 Tomi



