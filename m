Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0CHWGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:06:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27685 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab0CHWGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=rlrKA3YIsgQiewQSaS2Go2OXZLG8AjZa7BsTO1vs7Je37m8iQqXPEtF0JMksnGviDh
         EVtafHrnyYupZlOo3K1D/AiFls/zrP/JA2Q64wGcm0zfO2L78z9e1GxECx+n1WQJpHnv
         aVNi11naBYjMueYB5p7L4DMHlxdrLbm3pfmDw=
Message-ID: <4B9574EB.3080303@gmail.com>
Date: Mon, 08 Mar 2010 23:06:35 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.2 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.34-rc1
References: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1003081204510.3669@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2010 09:33 PM, Linus Torvalds wrote:
> It's out there now. I still have a few trees I already got pull requests 
> for, and that I want to look over a bit more (ceph, gdb tree etc), and 
> it's possible that I've just overlooked some other pull request.
> 
> So if you feel like you sent me a pull request bit might have been 
> over-looked, please point that out to me

Hi, yes, the writable limits tree:
http://lkml.org/lkml/2010/3/5/219

Maybe it was ignored on purpose. Either way, I would like to know to
decide whether to drop it from -next or not and wait for a 2.6.35 merge
window.

thanks,
-- 
js
