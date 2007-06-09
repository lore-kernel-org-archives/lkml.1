Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbXFITvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbXFITvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 15:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758886AbXFITu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 15:50:59 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:33275 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760082AbXFITu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 15:50:57 -0400
Date: Sat, 9 Jun 2007 21:50:52 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: dummy@foobar-g4
To: Andreas Hartmann <andihartmann@01019freenet.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: crash with linux 2.6.16 under high network traffic
In-Reply-To: <f4715r$4pu$1@p54A182E9.dip0.t-ipconnect.de>
Message-ID: <alpine.DEB.0.99.0706092147201.8312@foobar-g4>
References: <f4715r$4pu$1@p54A182E9.dip0.t-ipconnect.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Andreas Hartmann wrote:
> After the first of the files is closed and the second has been started,
> the machine is getting slower and slower and tons of the following
> messages can be found in messages (that's the last one - afterwards the
> machine crashed silently).

Is this 2.6.16 or 2.6.16.x? Adrian Bunk is maintaining a 2.6.16-stable 
tree, you know - maybe this one has been already addressed?

http://www.de.kernel.org/pub/linux/kernel/v2.6/linux-2.6.16.52.tar.bz2

C.
-- 
make bzImage, not war
