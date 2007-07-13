Return-Path: <linux-kernel-owner+w=401wt.eu-S1763674AbXGMUXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763674AbXGMUXt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 16:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbXGMUXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 16:23:41 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:39823 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158AbXGMUXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 16:23:40 -0400
Date: Fri, 13 Jul 2007 22:23:20 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: linuxppc-dev@ozlabs.org
cc: Nathan Lynch <ntl@pobox.com>, linux-kernel@vger.kernel.org
Subject: Re: Weird oopses with 2.6.22-rc7 [SOLVED]
In-Reply-To: <alpine.DEB.0.99.0707130840470.18512@sheep.housecafe.de>
Message-ID: <alpine.DEB.0.99.0707132221320.18512@sheep.housecafe.de>
References: <alpine.DEB.0.99.0707130016270.18512@sheep.housecafe.de>
 <20070712233719.GK17955@localdomain>
 <alpine.DEB.0.99.0707130840470.18512@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007, Christian Kujau wrote:
> Ah, this seem to have fixed http://lkml.org/lkml/2007/7/8/21 and really
> looks promising, I'll try 2.6.22-git2 now.

for the record: running 2.6.22-git3 now and the Oopses went away ;)

thanks,
Christian.
-- 
BOFH excuse #352:

The cables are not the same length.
