Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbXEQB7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbXEQB7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 21:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXEQB7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 21:59:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:33882 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbXEQB7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 21:59:33 -0400
Subject: Re: radeonfb and X800 cards
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Daniel Drake <dsd@gentoo.org>
Cc: kronos.it@gmail.com, linux list <linux-kernel@vger.kernel.org>,
       Jimmy.Jazz@gmx.net
In-Reply-To: <464BB43D.2020407@gentoo.org>
References: <464BB43D.2020407@gentoo.org>
Content-Type: text/plain
Date: Thu, 17 May 2007 11:59:23 +1000
Message-Id: <1179367164.32247.256.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-16 at 21:47 -0400, Daniel Drake wrote:
> Hi,
> 
> Did anything happen to the patch titled "radeonfb: add support for newer 
> cards"?
> http://lwn.net/Articles/215965/
> 
> Jimmy at http://bugs.gentoo.org/174063 has extended upon this with some 
> further fixes based on code the in X11 driver. The patches are on the 
> bug report.
> 
> Ben, where can the most up-to-date radeonfb code be found?

upstream. I haven't released anything else so far. Does the patch still
apply ?

Ben.


