Return-Path: <linux-kernel-owner+w=401wt.eu-S937809AbZDJG7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937809AbZDJG7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 02:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763065AbZDJG7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 02:59:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:40776 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762935AbZDJG7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 02:59:40 -0400
Date: Fri, 10 Apr 2009 09:01:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove pointless strdup() on arguments passed to new_module()
Message-ID: <20090410070145.GC20617@uranus.ravnborg.org>
References: <49B90DFE.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B90DFE.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 12:28:30PM +0000, Jan Beulich wrote:
> new_module() itself already calls strdup() on its modname parameter.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Applied.

	Sam
