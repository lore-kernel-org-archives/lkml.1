Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbYJWR5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbYJWR5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 13:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYJWR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 13:57:31 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:45857 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYJWR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 13:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fT9YvMDRN98nipC2WRPEj0Zh7eATjlssgO5423ZhuFkAI0N5hc4s1JVN118IENyZIR
         niCf4Z9QFjrcBi1oT6rzey85H6sHv+Yj1h6y+H9fYVWYv3/jiqojgTkFONr8bPBVApF8
         Dtn77Fu/5H7o5xaFCYyn327zXePQ+SlKzw9j0=
Date: Thu, 23 Oct 2008 21:57:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: next-20081023 x86_64 boot hang: int3
Message-ID: <20081023175723.GD29659@localhost>
References: <4900B7CC.5060005@oracle.com> <20081023175008.GC29659@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023175008.GC29659@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Thu, Oct 23, 2008 at 09:50:08PM +0400]
...
| 
| Hi Randy,
| 
| i don't remember the details -- these int3 opcodes are likely to
| come from some paging or stack protector... hmm... can't remember
| absolutely :) There was a thread on LKML about half a year ago about
| why to fill pages with int3 opcode. But I may be absolutely wrong :)
| 
| 		- Cyrill -

Hmm, I think I'm not in touch don't play attention on this mail,
sorry :)

		- Cyrill -
