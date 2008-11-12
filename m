Return-Path: <linux-kernel-owner+w=401wt.eu-S1755118AbYKLURh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118AbYKLURh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 15:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYKLUR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 15:17:27 -0500
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:52836 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692AbYKLUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 15:17:26 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=SMbWj8aygjUh8R9AAXPw8nFENhWU+zYQIgWmNzGh2An+uu0DxCPfFFyXXoUD3QNR;
  h=Received:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Message-ID: <491B39CF.5050201@earthlink.net>
Date: Wed, 12 Nov 2008 15:17:19 -0500
From: Stephen Clark <sclark46@earthlink.net>
Reply-To: sclark46@earthlink.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27.2 hda-intel weak sound from speakers
References: <491B1409.9040705@earthlink.net> <s5h7i78ixu1.wl%tiwai@suse.de>
In-Reply-To: <s5h7i78ixu1.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: a437fbc6971e80f61aa676d7e74259b7b3291a7d08dfec79f59c2bda7c077ab36bca1450be14c936350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 208.118.36.229
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Wed, 12 Nov 2008 12:36:09 -0500,
> Stephen Clark wrote:
>> Hi,
>>
>> I am running linux 2.6.27.2 ontop of a Fedora 8 distro. The sound from the 
>> speakers is barely audible with all the mixer settings at max, this includes
>> the pulseaudio settings. This is on an ASUS laptop with intel-hda.
> 
> Try to pass either model=asus-a7j or model=asus-a7m.  One of them may
> give a bit better result.
> 
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
Thanks Takashi, I'll give it a try and report the result - OBTW this is an
ASUS S96F - which was a build to order (Verified By Intel - VBI) laptop - which 
corresponds to ASUS Z96F
laptop.

Regards,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)


