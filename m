Return-Path: <linux-kernel-owner+w=401wt.eu-S1756287AbXEQOjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287AbXEQOjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 10:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbXEQOjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 10:39:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:21263 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbXEQOjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 10:39:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=E0KPow+TuMP0VAk4mLbId6YxPLZ+znyi43hHpqV3kWxNpyRq8b5ZXaMoArj+OWSBJOp5OEUajs68jYX0F/SJDEBxcfBDfQR/x16WWRTSYv7BCrkCw29NTDcRHjYCooc6iaOX16nDTZfnZ6PZvs3UFWwpAckonw8KRez36N1kV5Y=
Date: Thu, 17 May 2007 18:38:30 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Richard Henderson <rth@twiddle.net>,
       linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ALPHA: MARVEL - check for allocated memory
Message-ID: <20070517143830.GB8991@cvg>
References: <20070516181214.GA16348@cvg> <20070516114455.c0ee691e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070516114455.c0ee691e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


And I really sorry about mixing whitespace cleanup and the checking
itself. I'll never do that again :( sorry

		Cyrill

