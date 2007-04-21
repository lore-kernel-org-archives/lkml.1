Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbXDUQQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbXDUQQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXDUQQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbXDUQQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:16:57 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SuSE Labs, Novell
To: Tetsuo Handa <penguin-fsdevel@i-love.sakura.ne.jp>
Subject: Re: [d_path 3/7] Add d_namespace_path() to compute namespace relative pathnames
Date: Sat, 21 Apr 2007 18:16:37 +0200
User-Agent: KMail/1.9.5
Cc: alan@lxorguk.ukuu.org.uk, jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, akpm@linux-foundation.org
References: <20070412090809.917795000@suse.de> <20070419234704.123573327@schurl.suse.de> <200704212157.GCF15034.WFMQGJHFTFOtEOV@I-love.SAKURA.ne.jp>
In-Reply-To: <200704212157.GCF15034.WFMQGJHFTFOtEOV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704211816.38501.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 14:57, Tetsuo Handa wrote:
> So, you may want customized version of d_namespace_path()?

No. d_namespace_path() returns valid pathnames, just like d_path() does. 
Whatever quoting needed can be added to the resulting pathname.

Andreas
