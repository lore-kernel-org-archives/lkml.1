Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYIMA06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYIMA06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYIMA0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:26:50 -0400
Received: from scing.com ([217.160.110.58]:50323 "EHLO scing.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYIMA0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:26:49 -0400
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
X-GoodMailTo: skipped
From: Janne Grunau <j@jannau.net>
To: Jarod Wilson <jwilson@redhat.com>
Subject: Re: [PATCH 02/18] lirc serial port receiver/transmitter device driver
Date: Sat, 13 Sep 2008 02:26:35 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>,
       linux-kernel@vger.kernel.org, Christoph Bartelmus <lirc@bartelmus.de>
References: <200809112149.25762.stefan.bauer@cs.tu-chemnitz.de> <200809121224.34345.jwilson@redhat.com>
In-Reply-To: <200809121224.34345.jwilson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809130226.35998.j@jannau.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 September 2008 18:24:33 Jarod Wilson wrote:
> > I just want to thank you very much for your work and give you my
> > Tested-By. Todays git (b2e9c18a32423310a309f94ea5a659c4bb264378)
> > works well here with lirc-0.8.3 userspace on a Pentium
> > 3/i815-system.
>
> Oh good! I haven't broken anything further w/my changes up to
> b2e9c18... ;) I've got another slew of updates to lirc_serial still
> pending though

I hope I haven't broken anything with my lirc_dev changes. I doubt I'll 
have a change to test it before monday.

Janne
