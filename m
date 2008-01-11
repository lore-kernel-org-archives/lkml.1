Return-Path: <linux-kernel-owner+w=401wt.eu-S1761896AbYAKSjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761896AbYAKSjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 13:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbYAKSj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 13:39:28 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52382 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231AbYAKSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 13:39:28 -0500
Date: Fri, 11 Jan 2008 13:39:27 -0500
To: Bodo Eggert <7eggert@gmx.de>
Cc: Matthias Schniedermeyer <ms@citd.de>, Tuomo Valkonen <tuomov@iki.fi>,
       linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080111183927.GM2310@csclub.uwaterloo.ca>
References: <9JpbI-5yi-9@gated-at.bofh.it> <9Jqri-7ym-17@gated-at.bofh.it> <9JqUn-8bF-15@gated-at.bofh.it> <9JvKj-85h-41@gated-at.bofh.it> <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JDMeb-0003qH-Mv@be1.7eggert.dyndns.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 05:22:45PM +0100, Bodo Eggert wrote:
> What can happen if someone does tune2fs -Lroot /dev/usbstick
> and puts that stick into this system?

Don't know.  I use UUIDs rather than LABELs.  Having duplicated labels
just means being careless.  Having duplicate UUIDs should require being
malicous.

--
Len Sorensen
