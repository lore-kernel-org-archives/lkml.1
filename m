Return-Path: <linux-kernel-owner+w=401wt.eu-S1763949AbYESUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763949AbYESUDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763650AbYESUDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:03:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49048 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760518AbYESUDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:03:00 -0400
Date: Mon, 19 May 2008 20:51:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH 00/57] watchdog: Giant scrub
Message-ID: <20080519205106.1a042355@core>
In-Reply-To: <20080519112148.4d078ad4.akpm@linux-foundation.org>
References: <20080519124659.31722.51847.stgit@core>
	<20080519112148.4d078ad4.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> and hasn't had a commit in six weeks, missed the merge window and the
> most recent commit is titled "[WATCHDOG] rc32434_wdt: critical
> bugfixes".
> 
> Wim, come back!
> 
> (Happily there appears to be little overlap between the two diffstats there)

If Wim wants I'll start folding them all together into one tree.

Alan
