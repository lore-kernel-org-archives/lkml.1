Return-Path: <linux-kernel-owner+w=401wt.eu-S1761224AbZCaByd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224AbZCaByd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:54:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbZCaByX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:54:23 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43658 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZCaByW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:54:22 -0400
Date: Tue, 31 Mar 2009 10:49:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] maple: fix Error in kernel-doc notation
Message-ID: <20090331014948.GA27594@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	lkml <linux-kernel@vger.kernel.org>,
	akpm <akpm@linux-foundation.org>,
	torvalds <torvalds@linux-foundation.org>
References: <20090328215017.1ae9b798.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328215017.1ae9b798.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 09:50:17PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc error in maple (it's not kernel-doc):
> 
> Error(drivers/sh/maple/maple.c:782): cannot understand prototype: 'struct bus_type maple_bus_type = '
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Paul Mundt <lethal@linux-sh.org>

Applied, thanks Randy.
