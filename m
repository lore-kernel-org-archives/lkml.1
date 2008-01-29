Return-Path: <linux-kernel-owner+w=401wt.eu-S1759739AbYA2FH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739AbYA2FH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 00:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYA2FGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 00:06:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40873
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbYA2FGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 00:06:32 -0500
Date: Mon, 28 Jan 2008 21:06:49 -0800 (PST)
Message-Id: <20080128.210649.238721754.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] [SPARC/SPARC64] fix usage of .section .sched.text in
 assembler code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080126225439.GB27215@uranus.ravnborg.org>
References: <20080126225439.GB27215@uranus.ravnborg.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 26 Jan 2008 23:54:39 +0100

> ld will generate an unique named section when assembler do not
> use "ax" but gcc does. Add the misisng annotation.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Ingo Molnar <mingo@redhat.com>

Applied, thanks Sam.
