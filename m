Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZBXSmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZBXSmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 13:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750882AbZBXSmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 13:42:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:63505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbZBXSmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 13:42:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iz9Zsbd5r9+47O24hhy1ZoRgZstu0PcDt93H7gfHiMzN8H1yhnNHAfeq1Gt39Z6EnK
         nd0xsAm+4Srnbo2eqkeTsfoKUmxKEFPQQy8uxgH4WpKFosCww1xpR2xSvIlfGIPj0Ubk
         xMaaXOsTdx2eP/fEjF+VUTd8pHdynufODTYFI=
Date: Tue, 24 Feb 2009 21:48:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] pull /proc/kpageflags fixlet
Message-ID: <20090224184818.GA6558@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

	git://git.kernel.org/pub/scm/linux/kernel/git/adobriyan/proc.git proc-linus

to get

Helge Bahmann (1):
      proc: fix PG_locked reporting in /proc/kpageflags

 fs/proc/page.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
