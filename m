Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbZDMPwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbZDMPwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360AbZDMPwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:52:23 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36196 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbZDMPwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:52:22 -0400
Subject: Re: [PATCH 1/3] powerpc, Makefile: Make it possible to safely
	select CONFIG_FRAME_POINTER
From: Steven Rostedt <srostedt@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090405210756.GG24374@uranus.ravnborg.org>
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
	 <20090320164429.GA28037@oksana.dev.rtsoft.ru>
	 <20090405210756.GG24374@uranus.ravnborg.org>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 13 Apr 2009 11:51:25 -0400
Message-Id: <1239637885.21121.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2009-04-05 at 23:07 +0200, Sam Ravnborg wrote:

> 4) The individual "HAVE_* members should be sorted alphabetically in the arch
>    Kconfig file (which they seldomly are :-( )

Note, my first port of Ftrace to PPC sorted the Kconfig HAVE_* macros,
which ended up being reverted :-/

http://www.mail-archive.com/linuxppc-dev@ozlabs.org/msg21222.html

As stated, I did the sort without reporting the change in the
change-log, which I should have done.

-- Steve


