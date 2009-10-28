Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbZJ1PtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbZJ1PtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 11:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754672AbZJ1PtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 11:49:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbZJ1PtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 11:49:24 -0400
Subject: Re: [PATCH v3 0/8] tracing: recordmcount.pl Bug fixes and code
 improvement
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Hong <lihong.hi@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20091028045532.GA30036@uhli>
References: <20091028045532.GA30036@uhli>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 11:49:26 -0400
Message-Id: <1256744966.26028.1400.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 12:57 +0800, Li Hong wrote:
> Hi Steven,
> 
> This a following version for last patch series on recordmcount.pl. I have made
> several changes according to your suggestions. Hopefully, they are ready to be
> applied into your tree.
> 
> Changes include:
> 
>   - Improved the documentation amendment patch.
>   - Keep the C like notation for error paths.
>   - Drop the 'exit early' patch. Yes, it's not much useful, and actually, as
>   you told me, there was a bug in it :)
>   - minor typos and cleanups.
> 
> Thanks very much for your elaborate review and feedback.

Thanks Li!

I'll pull them in, do some basic tests and send them off to Ingo.

I appreciate your work,

-- Steve


