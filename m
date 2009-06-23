Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbZFWES5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbZFWES5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbZFWESs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:18:48 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57228 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZFWESr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:18:47 -0400
Date: Tue, 23 Jun 2009 06:21:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Chris Simmonds <chris@2net.co.uk>, Arnd Bergmann <arnd@arndb.de>,
       Marco <marco.stornelli@gmail.com>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] Pramfs: Include files
Message-ID: <20090623042106.GA17159@uranus.ravnborg.org>
References: <4A33A7EC.6070008@gmail.com> <200906221317.04166.arnd@arndb.de> <4A3FC7F1.5050108@gmail.com> <200906222033.20883.arnd@arndb.de> <4A3FDBFE.8050509@2net.co.uk> <20090622203034.GA12587@uranus.ravnborg.org> <4A3FFF17.9020701@am.sony.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3FFF17.9020701@am.sony.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > It should be possible to read a file-system on your x86 64bit
> > box that you wrote with your small powerpc target.
> For a (NV)RAM-based filesystem??  WTH???

dd the full image - dig into it.
Usefull is you have post-mortem info there.

	Sam
