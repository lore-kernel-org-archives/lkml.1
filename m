Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZFTLg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZFTLg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbZFTLgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:36:20 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55361 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZFTLgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:36:20 -0400
Date: Sat, 20 Jun 2009 13:38:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: fix param matching for array params
Message-ID: <20090620113839.GB32507@uranus.ravnborg.org>
References: <4A398C5B.6040705@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A398C5B.6040705@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 05:37:47PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix function actual parameter vs. kernel-doc description matching
> so that a warning is not printed when it should not be:
> 
> Warning(include/linux/etherdevice.h:199): Excess function parameter 'addr' description in 'is_etherdev_addr'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied,
	Sam

