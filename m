Return-Path: <linux-kernel-owner+w=401wt.eu-S937707AbYEVBZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937707AbYEVBZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759548AbYEVBZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:25:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45604
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1763303AbYEVBZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:25:05 -0400
Date: Wed, 21 May 2008 18:25:00 -0700 (PDT)
Message-Id: <20080521.182500.227458079.davem@davemloft.net>
To: harvey.harrison@gmail.com
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, paulus@samba.org,
       tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-*
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211419419.6908.12.camel@brick>
References: <20080522005657.GU28946@ZenIV.linux.org.uk>
	<alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
	<1211419419.6908.12.camel@brick>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Date: Wed, 21 May 2008 18:23:39 -0700

> What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>

Keep in mind that the eventual intent there is that, like
powerpc, we have one "sparc" arch directory.
