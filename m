Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYIWVjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYIWVjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYIWVjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:39:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYIWVjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:39:12 -0400
Date: Tue, 23 Sep 2008 23:39:13 +0200
From: Karel Zak <kzak@redhat.com>
To: Martin Steigerwald <ms@teamix.de>
Cc: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for CFS SCHED_IDLE priority in chrt
Message-ID: <20080923213913.GP28147@nb.net.home>
References: <200809231435.54985.ms@teamix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809231435.54985.ms@teamix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 02:35:49PM +0200, Martin Steigerwald wrote:
> ms@mango> autoconf      ~/lokal/Kernel/Dokumentation/util-linux-ng
> configure.ac:7: error: possibly undefined macro: AM_INIT_AUTOMAKE
>       If this token and others are legitimate, please use m4_pattern_allow.
>       See the Autoconf documentation.
> configure.ac:37: error: possibly undefined macro: AM_CONDITIONAL
> configure.ac:190: error: possibly undefined macro: AM_GNU_GETTEXT_VERSION
> configure.ac:191: error: possibly undefined macro: AM_GNU_GETTEXT
> ms@mango> ./configure      ~/lokal/Kernel/Dokumentation/util-linux-ng
> configure: error: cannot find install-sh or install.sh in config "."/config
> 
> when trying to compile util-linux-ng from GIT. (Note: I have no glue about 
> autoconf, I only ever started an pre-existing ./configure script). I tried 
> with autoconf 2.61-8 from Debian Lenny.

 ./autogen.sh
 
> I will test this commit if someone gives me a hint on how to compile 
> util-linux-ng.

 see README.devel


 Applied with minor changes, thanks.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
