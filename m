Return-Path: <linux-kernel-owner+w=401wt.eu-S1763980AbXFCA0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763980AbXFCA0L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 20:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbXFCAZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 20:25:58 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:33768 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762915AbXFCAZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 20:25:58 -0400
Date: Sun, 3 Jun 2007 01:25:35 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
Message-ID: <alpine.DEB.0.99.0706030115410.16496@sheep.housecafe.de>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <4661F511.4070207@goop.org>
 <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Justin Piszcz wrote:
> On Sat, 2 Jun 2007, Jeremy Fitzhardinge wrote:
>> XFS currently has a data-corrupting bug, where files which were appended
>> by small amounts may lose their updates on umount - I see this
>> corrupting hg repos. There's a patch which works for me, and is in
>> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.

Just for the record, you mean this one:
http://lkml.org/lkml/2007/5/12/93   ..right? (haven't been bitten by 
this one...yet)

> Ah that's it- and USB appears to be broken as well, I'll stick with 2.6.21.3 
> for now.

Got any pointers? I'm using USB right now, one is i386 with 2.6.22-rc3, 
another one is powerpc, tracking -git and USB seems to work.

C.
-- 
BOFH excuse #15:

temporary routing anomaly
