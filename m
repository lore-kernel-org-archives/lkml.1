Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbXENRdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbXENRdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 13:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbXENRc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 13:32:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:45781 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbXENRcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 13:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nPR2uwPU7dAkz2SBgf1yJua87SvFF9PKQ4kTTCsqvaETbpxDXApkdBzhgRRSz50ryCAjMYw4nn5LhGL4pVUcsu5cdedRYxkuNuTAIv0A6IHJuuwKMRLz1nbGBRBNamL9BOhARvDMZ2MJZlrCURTmpaqlnluUSFTYdDFsoejuZ2Q=
Message-ID: <46489D3B.8050805@gmail.com>
Date: Mon, 14 May 2007 19:32:43 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Francesco Pretto <ceztko@gmail.com>
CC: Phillip Susi <psusi@cfl.rr.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Weird hard disk noise on shutdown (bug #7674)
References: <fa.Ia7dfo7Zd5kB6KhSYisfswa1aj4@ifi.uio.no>	 <fa.YHt2nIlQmoW5r2enmTSzsaySwH4@ifi.uio.no> <45DD0348.5040005@shaw.ca>	 <e5ab0f710702231235ucb559eerb3639ec312aa312a@mail.gmail.com>	 <463B858E.6060002@cfl.rr.com> <463B99EE.2090001@gmail.com> <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
In-Reply-To: <e5ab0f710705061119k35ba223j2ecca6e0f8495ed5@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francesco Pretto wrote:
> 2007/5/4, Tejun Heo <htejun@gmail.com>:
>> Yeap, the third iteration of the patch just got submitted.
>>
>>   http://thread.gmane.org/gmane.linux.ide/18485
>>
>> Unfortunately, there doesn't seem to be an easy way out.  We'll need
>> userland shutdown(8) update.
>>
>> -- 
>> tejun
>>
> 
> Ok, i can't understand if the patch will be included in 2.6.22 (i
> didn't see it in the Andrew Morton merge plan). However, if you can
> confirm the inclusion, i can send bug reports for ubuntu and gentoo. I
> can even send an email to Miquel van Smoorenburg, who should be the
> mainstream sysvinit developer (and probably the last maintainer).

Okay, the patch made upstream and webpage posted.

 http://linux-ata.org/shutdown.html

-- 
tejun
