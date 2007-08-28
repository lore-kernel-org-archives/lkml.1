Return-Path: <linux-kernel-owner+w=401wt.eu-S1756381AbXH1XgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbXH1XgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 19:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXH1XgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 19:36:00 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:26822 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbXH1Xf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 19:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R+7m+2iz/PfDNJBYXGmfFRe/fekSEqtdbODbpclXarqeDLLY+yCQPlncPoou0M0SZjFoGhyaU1+hXJsAqaz6Flk6hsixDXUQtK9MnWCpjpJQQE/uM1i5GZBKVJ9STy942r4QEpo702ME6jtKboWH7ykXeUr4xYnY3VxVBi/tbaI=
Message-ID: <6bffcb0e0708281635v2fdca60bv40099d0583599637@mail.gmail.com>
Date: Wed, 29 Aug 2007 01:35:57 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Alexey Dobriyan" <adobriyan@sw.ru>
Subject: Re: 2.6.23-rc4: maxcpus still broken
Cc: torvalds@osdl.org, len.brown@intel.com, ak@suse.de,
       linux-kernel@vger.kernel.org, "Hugh Dickins" <hugh@veritas.com>
In-Reply-To: <20070828111431.GA27707@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070828111431.GA27707@localhost.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On 28/08/07, Alexey Dobriyan <adobriyan@sw.ru> wrote:
> Every time I try to boot with maxcpus=1 it dies show_stat():

Is this a regression?

Hugh fixed some issues on x86-64 commit 813409771731d80e6fa94199adf99f2269a4afc0

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
