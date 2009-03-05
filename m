Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZCENGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZCENGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbZCENGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:06:03 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:44217 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbZCENGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:06:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gUWYtj8aY7tg1fBbQ+bfmIT6eYyeA0B7sWrFA8UwooxkSSHQenCTHQ/izPfw2ncWRV
         R2ItgyZE4XpXR17KukPYfAlEF9FvZ2l5uKmK8q+zo9f8Zc7jMLTGuvxC+GnTY/P0KQ6h
         UyhzdPMRyETKzuZA5UeRMUfttkRAAuICzRNz0=
Date: Thu, 5 Mar 2009 21:06:10 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: um: WARNING: vmlinux: 'memcpy' exported twice. Previous export
	was in vmlinux
Message-ID: <20090305130610.GA4265@hack.private>
References: <49AFC206.9080004@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AFC206.9080004@panasas.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 02:13:58PM +0200, Boaz Harrosh wrote:
>On today's linus v2.6.29-rc7-3-g559595a
>
>Doing make ARCH=um defconfig & make ARCH=um
>give's me:
>
>LD vmlinux.o
>MODPOST vmlinux.o
>WARNING: vmlinux: 'memcpy' exported twice. Previous export was in vmlinux
>
>
>Sorry if this is a duplicate report
>

Weird...
I tried to compile like what you said, I can't reproduce it.

Which gcc are you using?

Thanks.

-- 
Do what you love, f**k the rest! F**k the regulations!
 
