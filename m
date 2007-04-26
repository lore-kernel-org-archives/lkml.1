Return-Path: <linux-kernel-owner+w=401wt.eu-S1031224AbXDZNEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031224AbXDZNEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031223AbXDZNEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:04:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:36440 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031224AbXDZNEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=Xx/lt1vKsqXpqZGW8ccTEdWOPXg1/2oNOVWdY7UWHLtrPpyM3rPnOhhcm+htZLAK1gasznXAQuhCfUg/ZN4UC7hfqkOAI4OcOOgYeLttQzlpCWoAx0zTp71ZDSmJlzTR2NXa5Axy8Hp6kVQgXfXx7nuC3wX48U+ov3bxRUp/mCY=
Date: Thu, 26 Apr 2007 15:03:39 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Sunil Naidu <akula2.shark@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.21 - something wrong with dmesg.
Message-ID: <20070426130339.GB16833@slug>
References: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8355959a0704260514s39afa1ecj3e7e077e482769a8@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:44:40PM +0530, Sunil Naidu wrote:
> Hello,
> 
> I did compile the kernel, boots good ;-) BTW, does anyone (on P-III)
> facing a memory check skip or sort of? Not getting RAM info in the
> dmesg.  Unable to get dmseg from the start of the gcc check! Any clue?
> Here is the dmesg I get on my box:
Don't you need to increase CONFIG_LOG_BUF_SHIFT ?
Regards,
Frederik
