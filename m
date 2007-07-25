Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbXGYStB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbXGYStB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 14:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759836AbXGYSsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 14:48:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:39000 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbXGYSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 14:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pdA5+C0dRZI3EM/mTcAixKYJB/OQgb2tWD66cQJNyc+FqLv/iTkBddR31nxhc04Gd+fQ3/0oa8sbLH8/iEo1aTcIIMMafClAKRSnrO+hUXjLC8MoRcmaSsbi2ohMdp9ifgmRcpO2ZrniIR3BRVVXjarmLX/6CPV3HuAR+0ZEnN4=
Message-ID: <6bffcb0e0707251148m219d1c9fqb557d3e5364f679b@mail.gmail.com>
Date: Wed, 25 Jul 2007 20:48:50 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm1
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
>
>

Andi, this might be interesting for you

make allmodconfig
make
[...]
WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c02041b3 00705601   R_386_32 c0308aa8  _sdata

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
