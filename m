Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZFTLgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZFTLgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:36:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZFTLfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:35:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:39451 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZFTLfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:35:55 -0400
Date: Sat, 20 Jun 2009 13:38:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel-doc: ignore kmemcheck_bitfield_begin/end
Message-ID: <20090620113814.GA32507@uranus.ravnborg.org>
References: <4A398BFF.2090308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A398BFF.2090308@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 05:36:15PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Teach kernel-doc to ignore kmemcheck_bitfield_{begin,end} sugar
> so that it won't generate warnings like this:
> 
> Warning(include/net/sock.h:297): No description found for parameter 'kmemcheck_bitfield_begin(flags)'
> Warning(include/net/sock.h:297): No description found for parameter 'kmemcheck_bitfield_end(flags)'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied.

	Sam
