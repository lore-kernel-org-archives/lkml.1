Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZFTL37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZFTL37 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 07:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZFTL3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 07:29:51 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38427 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbZFTL3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 07:29:51 -0400
Date: Sat, 20 Jun 2009 13:32:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
       akpm@linux-foundation.org, jirislaby@gmail.com
Subject: Re: [Patch] kbuild: fix a build error during make htmldocs
Message-ID: <20090620113209.GA31560@uranus.ravnborg.org>
References: <20090619070909.6422.28484.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619070909.6422.28484.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:06:54AM -0400, Amerigo Wang wrote:
> 
> Fix the following build error when do 'make htmldocs':
> 
>  DOCPROC Documentation/DocBook/debugobjects.xml
> exec /scripts/kernel-doc: No such file or directory
> exec /scripts/kernel-doc: No such file or directory
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Sam <sam@ravnborg.org>
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Wang.

	Sam
