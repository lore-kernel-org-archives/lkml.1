Return-Path: <linux-kernel-owner+w=401wt.eu-S965742AbXCSHjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965742AbXCSHjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 03:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965751AbXCSHjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 03:39:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:7228 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965742AbXCSHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 03:39:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=kZuZzn3sK/cHUUKzf/qJCFjSPMfmqDZgJuxxnOSjogGNORegSZnIXJPMURPccVAwRrr3jnFwygWJwazBWt9Wi9tkFdhnkgPd86vIYiWNLr80FpebPyw+NBcPGNwj4QBsDNcYFCXS8Pn55CyPWZeCbQBIOVD7YhUB024yPUNolGU=
Message-ID: <45FE3E23.1010705@gmail.com>
Date: Mon, 19 Mar 2007 16:39:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703182131.00476.christiand59@web.de> <45FDF9EE.20303@gmail.com> <200703190808.00746.christiand59@web.de>
In-Reply-To: <200703190808.00746.christiand59@web.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> Yes, for me the problem was introduced recently. I have moved around terabytes 
> (sic!) on my discs with older kernels and I never got errors.

There is always the possibility of disk going bad, so it would be great
if you can boot an older kernel and verify that the problem doesn't
occur on it.

Thanks.

-- 
tejun
