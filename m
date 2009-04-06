Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbZDFFBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbZDFFBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 01:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbZDFFBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 01:01:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:53551 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbZDFFBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 01:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gwL28HyFYSNy54zdmgtjFGyFcmf0u4HUTY3zSnwapGbF9TDmjEi5A0fiiCi60liX3F
         4il7oFYUZranmVi0ooAMXlHSb9DBZlk/l8hmem/zcaNHS9iYEcGD/PqU30g/kzctoQWW
         hp2P/OlXGOQXFl3XzfxpZhg5T9G39ybK+RQTE=
Message-ID: <49D98C9E.2000507@gmail.com>
Date: Mon, 06 Apr 2009 07:01:18 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <ckpL0-3TE-3@gated-at.bofh.it> <ckpL0-3TE-5@gated-at.bofh.it> <ckpL0-3TE-7@gated-at.bofh.it> <ckpL0-3TE-9@gated-at.bofh.it> <ckpL0-3TE-11@gated-at.bofh.it> <ckpL0-3TE-1@gated-at.bofh.it> <cllvN-2Gf-1@gated-at.bofh.it> <49D0D788.6070405@gmail.com> <49D419E8.2080603@kernel.org> <49D4591B.3070807@gmail.com> <49D46096.1040701@kernel.org> <49D49B8A.7070408@gmail.com> <49D4C886.1010101@gmail.com> <49D6E7FA.3000306@kernel.org>
In-Reply-To: <49D6E7FA.3000306@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2009 06:54 AM, Tejun Heo wrote:
> Hello, Neil.
>
> Niel Lambrechts wrote:
>   
>>> Thanks for your help, I've done at least 5 hibernate cycles without the
>>> problem recurring, I'll keep at it for a while... :)
>>>       
>
> Hmmm..
>   
Hi Tejun,

I have tested your patch some more over the weekend as well as on
2.6.29.1, and suspend-to-disk and ram still works without a glitch for
me apart from the extra debugging being active.

Will the fix naturally make its way into the mainline kernel, or is
there any extra debugging/testing I can help with?

Regards,
Niel

