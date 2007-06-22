Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbXFVRRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbXFVRRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXFVRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:16:56 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:19389 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbXFVRQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:16:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BO3lOxO+B072nBHsJv39mDV7Gmcz7pH4LWp8azfg+/YoTe/nIC/coI7XlHprWwcoS6YMQPy0ic4VjK3XBsEXcNn6L+i95oLXE2zYhx6km+SWsIpJ8tk1DEVSmQeWAcK2ZXtUyC3mkjdOoKik3IRCYc9HyStRxo3AAwz2eMJZgv4=
Message-ID: <2e6659dd0706221016m1b9cc7efl501641940a39c3a9@mail.gmail.com>
Date: Fri, 22 Jun 2007 14:16:55 -0300
From: "Tomas Neme" <lacrymology@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Chinese translation of Documentation/HOWTO
Cc: "Li Yang-r58472" <LeoLi@freescale.com>, "Rob Landley" <rob@landley.net>,
       gregkh@suse.de, linux-kernel@vger.kernel.org, xiyou.wangcong@gmail.com,
       bryan.wu@analog.com, "TripleX Chung" <xxx.phy@gmail.com>,
       "Maggie Chen" <chenqi@beyondsoft.com>
In-Reply-To: <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <989B956029373F45A0B8AF0297081890D83001@zch01exm26.fsl.freescale.net>
	 <alpine.LFD.0.98.0706220950110.3593@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A little issue about "when is translation good"

I usually tell people to use vimtutor's example to set up syntax
highlighting in vim. I usually only install OSs in english because
translations tend to be poor and hard to comprehend.

Now, I'm from argentina, and I live with a lingüist. He doesn't handle
english very well, and he wanted to get rid of Windows, so we
installed ubuntu, Locale:SP_ARG.

vim is in spanish, and so is vimtutor. vimtutor's spanish translation
doesn't have anything on syntax highlighting: the translation is poor.

my point: IMHO it's better to have no translation than a poor one

T

-- 
|_|0|_|
|_|_|0|
|0|0|0|
