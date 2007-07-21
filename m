Return-Path: <linux-kernel-owner+w=401wt.eu-S1762431AbXGUKcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762431AbXGUKcL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXGUKb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:31:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751162AbXGUKb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:31:57 -0400
Date: Sat, 21 Jul 2007 03:31:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2o: defined but not used.
Message-Id: <20070721033133.ed47aa6a.akpm@linux-foundation.org>
In-Reply-To: <20070720225817.607502287@ayoka.breakpoint.cc>
References: <20070720225817.607502287@ayoka.breakpoint.cc>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 00:58:01 +0200 Sebastian Siewior <sebastian@breakpoint.cc> wrote:

> Got with randconfig

randconfig apparently generates impossible configs.  Please always
run `make oldconfig' after the randconfig, then do the test build.
