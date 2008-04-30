Return-Path: <linux-kernel-owner+w=401wt.eu-S1760846AbYD3NSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760846AbYD3NSe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbYD3NS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:18:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:40948 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbYD3NSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:18:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Pl3z6jqTESqEjVbb1DrkV78bv/haT3VF2lM2B26W4MO81Z0TwyJb1TLP1NLKxFp2EzngI22eLF2v6DfpgYH4wuWu7R4U/DkbSZpwCbKHjCnOQlp/Q9T0C/iEafFtp/wjZ1Z9Dv7P/R5V4c+Sues+YKxUARpLoZpuW5U92SV/jew=
Message-ID: <517f3f820804300618v5ae41a46q881be5247469b591@mail.gmail.com>
Date: Wed, 30 Apr 2008 15:18:20 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Slow DOWN, please!!!
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <48186E57.5070805@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080429.190352.137408408.davem@davemloft.net>
	 <4817EF91.4080800@davidnewall.com>
	 <20080429.211835.130816277.davem@davemloft.net>
	 <48186E57.5070805@davidnewall.com>
X-Google-Sender-Auth: f109e63ea164abe3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Take, as an example, the desire to NOT
>  record who gives good code and who gives bugs: that one clearly hit a
>  nerve, which it should not have except from people who feel guilty.

Speaking as someone who has found quite a few kernel bugs, but written
few (because I've written little kernel code ;-))...

No.  It hit a nerve because it's the simply wrong way of going about
things.  There is no use in assigning blame.

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
