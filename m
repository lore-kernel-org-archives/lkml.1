Return-Path: <linux-kernel-owner+w=401wt.eu-S1754616AbZFEVnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616AbZFEVnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZFEVnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:43:04 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51983 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZFEVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:43:03 -0400
Date: Fri, 5 Jun 2009 23:45:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] scripts: allow docproc invocation from external
Message-ID: <20090605214519.GD29008@uranus.ravnborg.org>
References: <1243785934-13936-1-git-send-email-jirislaby@gmail.com> <4A23FC2C.4060602@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A23FC2C.4060602@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 01, 2009 at 09:05:00AM -0700, Randy Dunlap wrote:
> Jiri Slaby wrote:
> > - getcwd returns path without a slash at the end, add the slash
> 
> Hi Jiri,
> 
> This part (above) fixes a bug, right?
> 
> > - add KBUILD_SRC env support, so that we can specify path for
> >   kernel (to know where scripts/kernel-doc resides) and SRCTREE
> >   (for searching files referenced in .tmpl) separately
> 
> Can you explain your usage a bit more so that I can understand some
> justification for this change?  (not that I'm objecting to it)

Randy - it took this as an "Acked-by" and applied the patch with that.
Please let me know if this is not ok.

	Sam
