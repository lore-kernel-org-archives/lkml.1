Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYLKKiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYLKKiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 05:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755008AbYLKKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 05:38:08 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:64591 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbYLKKiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 05:38:07 -0500
Date: Thu, 11 Dec 2008 11:38:00 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: Linux 2.6.28-rc8
Message-ID: <20081211103800.GC7394@gambetta>
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 05:04:39PM -0800, Linus Torvalds wrote:
> 
> Nothing overly exciting here. 

-rc8 could be made even less exciting, it seems, by adding this crutially
boring fix:
http://lkml.org/lkml/2008/12/1/345

It sits in -mm and fixes a regression in mainline (Bugzilla #12047).

Regards,
Frederik
