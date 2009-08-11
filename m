Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbZHKOZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbZHKOZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 10:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZHKOZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 10:25:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:44396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbZHKOZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 10:25:48 -0400
Date: Tue, 11 Aug 2009 16:25:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Nico Schottelius <nico-linux-20090804@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel Panic on v2.6.31-rc5-34-ga33a052
In-Reply-To: <20090804205309.GA6291@ikn.schottelius.org>
Message-ID: <alpine.LRH.2.00.0908111625040.11142@twin.jikos.cz>
References: <20090804205309.GA6291@ikn.schottelius.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, Nico Schottelius wrote:

> Running this kernel on the Lenovo x200 and switching from X to console 
> kernel panics the system.

It is not possible to debug this without you providing the kernel messages 
that preceeded the panic (you can use digital camera to capture the image, 
if you can't set up a serial console).

-- 
Jiri Kosina
SUSE Labs

