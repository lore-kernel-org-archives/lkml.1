Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbXFKW2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbXFKW2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 18:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbXFKW2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 18:28:07 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:37273 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXFKW2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 18:28:06 -0400
Date: Mon, 11 Jun 2007 15:28:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Message-ID: <20070611222800.GE3457@sequoia.sous-sol.org>
References: <1181236651.15435.1.camel@albrecht.rdi1.com> <200706072323.05576.dtor@insightbb.com> <1181325648.2437.5.camel@albrecht.rdi1.com> <d120d5000706081208q217ca432w6cc6d860a84700e8@mail.gmail.com> <1181582562.6982.5.camel@albrecht.rdi1.com> <d120d5000706111126w59c00bd2p826b7d9f588533ba@mail.gmail.com> <1181586424.2436.15.camel@albrecht.rdi1.com> <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com> <1181588095.2436.5.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181588095.2436.5.camel@albrecht.rdi1.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Albrecht (albrecht@rdi1.com) wrote:
> Yes, i8042.noaux works. Here's the dmesg output:
> 
> Linux version 2.6.21.4 (root@albrecht.rdi1.com) (gcc version 3.3.3) #1

Does 2.6.21.5 work w/out noaux on command line?

thanks
-chris
