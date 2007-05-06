Return-Path: <linux-kernel-owner+w=401wt.eu-S1750940AbXEFQ37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750940AbXEFQ37 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 12:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXEFQ37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 12:29:59 -0400
Received: from lixom.net ([66.141.50.11]:47758 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbXEFQ37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 12:29:59 -0400
Date: Sun, 6 May 2007 11:31:45 -0500
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patch 19/29] xen: Use the hvc console infrastructure for Xen console
Message-ID: <20070506163145.GA32291@lixom.net>
References: <20070504232051.411946839@goop.org> <20070504232120.890105448@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070504232120.890105448@goop.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 04:21:10PM -0700, Jeremy Fitzhardinge wrote:
> Implement a Xen back-end for hvc console.
> 
> From: Gerd Hoffmann <kraxel@suse.de>
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Signed-off-by: Chris Wright <chrisw@sous-sol.org>
> Cc: Olof Johansson <olof@lixom.net>

Acked-by: Olof Johansson <olof@lixom.net>
