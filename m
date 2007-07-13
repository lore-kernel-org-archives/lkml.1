Return-Path: <linux-kernel-owner+w=401wt.eu-S934796AbXGMGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbXGMGoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbXGMGoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:44:05 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:55699 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418AbXGMGoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:44:04 -0400
Date: Fri, 13 Jul 2007 08:43:56 +0200 (CEST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Nathan Lynch <ntl@pobox.com>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Weird oopses with 2.6.22-rc7
In-Reply-To: <20070712233719.GK17955@localdomain>
Message-ID: <alpine.DEB.0.99.0707130840470.18512@sheep.housecafe.de>
References: <alpine.DEB.0.99.0707130016270.18512@sheep.housecafe.de>
 <20070712233719.GK17955@localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Nathan Lynch wrote:
> Have you tried 2.6.22?  Linus committed a utimensat-related oops fix
> right before releasing it:

Ah, this seem to have fixed http://lkml.org/lkml/2007/7/8/21 and really 
looks promising, I'll try 2.6.22-git2 now.

thanks,
Christian.
-- 
BOFH excuse #208:

Your mail is being routed through Germany ... and they're censoring us.
