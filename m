Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbYEXUVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbYEXUVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbYEXUU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:20:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46928 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755353AbYEXUU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:20:58 -0400
Date: Sat, 24 May 2008 13:20:43 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
In-Reply-To: <20080524192540.GA28067@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.10.0805241320200.3081@woody.linux-foundation.org>
References: <20080524192540.GA28067@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Can we get the /etc/kernel-config regression fixed before even posting 
things like this? Please?

		Linus
