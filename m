Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbYHNK77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbYHNK77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 06:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbYHNK7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 06:59:50 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:41145 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683AbYHNK7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 06:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lZpVNvqSDT7HWixknccS/lA2WmHE0J7qf/2h37Rwo8XoKbQQU6LdvrKxPJo5yNTOmX
         2RNc5WC+TYXZ3wEdnxBUEu05Knb1dSgTm4xZ5WdTp5msOYv3BrouX7Fi+sWbquVWymka
         aoi4JgShvIH+0zID6uwMuXvaMUlbSd97WP43w=
Message-ID: <bc64b4640808140359w3ece18edo7bc2beb894d9c7d2@mail.gmail.com>
Date: Thu, 14 Aug 2008 14:59:43 +0400
From: Dmitry <dbaryshkov@gmail.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: Tree for linux-next
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080814095756.a0152a27.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080813161654.GA19599@doriath.ww600.siemens.net>
	 <20080814095756.a0152a27.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/14 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi Dmitry,
>
> On Wed, 13 Aug 2008 20:16:55 +0400 Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
>>
>> Please add a tree to linux-next. It contains some cleanup for Sharp
>> Zaurus PDA's. Since it contains a number of patches, it's preferable
>> to test it via linux-next, before commiting to Russell's/ALSA tree.
>
> I assume you have already posted these changes somewhere and had them
> reviewed and unit tested them, right?
>
>> The url to pull is git://github.com/lumag/linux-2.6.git#for-next
>
> $ git ls-remote git://github.com/lumag/linux-2.6.git
> fatal: protocol error: expected sha/ref, got '
> *********'
>
> Permission denied. Repository is not public.
>
> *********'

That's the github problem. I'll try to find another place to host this
git and will send a request again.
Sorry for the noise.

-- 
With best wishes
Dmitry
