Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbXCLXq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbXCLXq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752426AbXCLXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:46:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44539
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752431AbXCLXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:46:56 -0400
Date: Mon, 12 Mar 2007 16:46:52 -0700 (PDT)
Message-Id: <20070312.164652.108743760.davem@davemloft.net>
To: kernel@kolivas.org
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: RSDL v0.30 cpu scheduler for mainline kernels
From: David Miller <davem@davemloft.net>
In-Reply-To: <200703121058.11966.kernel@kolivas.org>
References: <200703121058.11966.kernel@kolivas.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Con Kolivas <kernel@kolivas.org>
Date: Mon, 12 Mar 2007 10:58:11 +1100

> http://ck.kolivas.org/patches/staircase-deadline/2.6.21-rc3-sched-rsdl-0.30.patch

FWIW, this boots and seems to work well on sparc64.  Tested
on UP SunBlade1500 and 24cpu Niagara T1000.
