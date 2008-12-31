Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYLaSOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYLaSOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:14:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbYLaSOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:14:38 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:39930 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYLaSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:14:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L3BCyj52c6by6XadYPU0yjK2kG/R2R56apvNLko+tnWTvzjD88RqBEpqAuQ6qrwxmi
         XW3FWbtM/Tjr8LPGU7rXGaeazJhqDYl25yenr8yXoaMAMdDgfTTIn56KqEYh7lSs+yC7
         n1OFEOcmKwWNDvC9hYtexViDlwXbydBaIE/Gc=
Message-ID: <9bd6b5360812311014l4b36ddcfj45f1b3e6103ca793@mail.gmail.com>
Date: Thu, 1 Jan 2009 02:14:35 +0800
From: sniper <s3c24xx@gmail.com>
To: "Daniel Phillips" <phillips@phunq.net>
Subject: Re: [Tux3] Tux3 report: A Golden Copy
Cc: "Dave Chinner" <david@fromorbit.com>, tux3@tux3.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Jeff Dike" <jdike@addtoit.com>
In-Reply-To: <200812310140.49503.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200812301935.49303.phillips@phunq.net>
	 <200812310000.55256.phillips@phunq.net>
	 <20081231083123.GF10725@disturbed>
	 <200812310140.49503.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I meet another problem. After the system was completely setupped,
the gdb interface will be covered with that system interaction interface.
So, I can't stop the system's running and add some new break point etc.
But I can do those operations in remote kgdb debugging.

Any method to fix this problem?

Thanks.
