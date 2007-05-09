Return-Path: <linux-kernel-owner+w=401wt.eu-S969779AbXEICGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969779AbXEICGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 22:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967446AbXEICGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 22:06:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54846
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S966416AbXEICGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 22:06:09 -0400
Date: Tue, 08 May 2007 19:06:10 -0700 (PDT)
Message-Id: <20070508.190610.08324075.davem@davemloft.net>
To: clameter@sgi.com
Cc: mpm@selenic.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: +
 fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm
 tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705081856110.17784@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705081852310.17784@schroedinger.engr.sgi.com>
	<20070508.185539.95059076.davem@davemloft.net>
	<Pine.LNX.4.64.0705081856110.17784@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 8 May 2007 18:57:04 -0700 (PDT)

> On Tue, 8 May 2007, David Miller wrote:
> 
> > I'm just reading over the code to figure out what to type to you, you
> > could read the code too it's not very complicated :-)
> 
> I have read it numerous times and my conclusion is that it uses the 
> descriptors for that purpose. But Matt claims they are not necessary. So I 
> am just trying to figure out how one can get to that conclusion.

He is saying the metadata is not necessary for allocated objects.
At least that's my take.
