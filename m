Return-Path: <linux-kernel-owner+w=401wt.eu-S1754143AbYACQyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbYACQyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYACQyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:54:16 -0500
Received: from krynn.se.axis.com ([193.13.178.10]:53993 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYACQyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:54:15 -0500
Date: Thu, 3 Jan 2008 17:53:31 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Clemens Koller <clemens.koller@anagramm.de>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove unused __dummy, CONST_ADDR and ADDR from CRIS bitops.h
Message-ID: <20080103165331.GA9512@axis.com>
References: <20071220100944.GG10888@axis.com> <20071222003025.148ea0ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071222003025.148ea0ad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 12:30:25AM -0800, Andrew Morton wrote:
> On Thu, 20 Dec 2007 11:09:44 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > Subject: [PATCH] Remove unused __dummy, CONST_ADDR and ADDR from CRIS bitops.h
> 
> It's nice (and conventional) to prefix the patch title with the subsystem
> name.

Sorry about that, will add that to my checklist.

> So this one would become
> 
> Subject: [PATCH] cris: remove unused __dummy, CONST_ADDR and ADDR from bitops.h
>
> Thanks.

No, thank you. :-)

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
