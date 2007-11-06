Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbXKFJMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbXKFJMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXKFJMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:12:32 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:47433 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbXKFJMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:12:31 -0500
Date: Tue, 6 Nov 2007 10:12:02 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] CRIS architecture: Correct compile errors
Message-ID: <20071106091202.GS7621@axis.com>
References: <20071030093353.GN11960@axis.com> <1194338443.24746.43.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194338443.24746.43.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 08:40:43AM +0000, David Woodhouse wrote:
> You don't need #ifdef __KERNEL__ on a file which isn't exported to
> userspace. Having removed that, I've applied it to my tree.

Ok, thanks, I'll do the same change in our internal CVS.

> dwmw2

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
