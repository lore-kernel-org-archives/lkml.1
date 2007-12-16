Return-Path: <linux-kernel-owner+w=401wt.eu-S932089AbXLPKMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089AbXLPKMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXLPKMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:12:40 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3921 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXLPKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:12:40 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Sun, 16 Dec 2007 11:14:39 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <200712161111.02770.m.kozlowski@tuxland.pl>
In-Reply-To: <200712161111.02770.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712161114.39437.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 	cat /proc/kpageflags on sparc64 causes the box to lock.
> I can not write on any terminal - but I can issue sysrqs and switch
> between consoles.
> 
> cat process hangs in read(3, ...
> 
> sysrq-w shows:
> 
> syslogd       D 000000000069240c     0  2470      1
> Call Trace:
>  [0000000000692224] 
>  [0000000000692224] 
>  [0000000000692224] 
>  [0000000000692224] 
>  [0000000000692224] 
>  [0000000000692224] 

aggrh ... please ignore.

Sent by mistake when retyping info from sparc (no camera right now :/)

Will reply soon with correct data.

