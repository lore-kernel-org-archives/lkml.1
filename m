Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYCWLH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYCWLH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbYCWLHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:07:13 -0400
Received: from ns01.unsolicited.net ([69.10.132.115]:35156 "EHLO
	ns01.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYCWLHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:07:12 -0400
X-Greylist: delayed 1336 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Mar 2008 07:07:12 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=simple; s=one; d=unsolicited.net;
	h=Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:Content-Type:Content-Transfer-Encoding;
	b=eOcVeth2u/JEsxxB74/u0QoaNI8anX18+Ig0ZQrhzzV4dmAdxgv53D3yImY+292LTSzINuv6xP6P3vfj1qozFw/uYE2kqlpmMn0tdQVGIy5vaeps7d/g3tjSf/v+4a+ZQAopyC2vdmonZEsm6lMcdvnehLoHBld6tySsJuSC+Ak=;
Message-ID: <47E63476.4020304@unsolicited.net>
Date: Sun, 23 Mar 2008 10:44:06 +0000
From: David <david@unsolicited.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Kai <epimetreus@fastmail.fm>
CC: linux-kernel@vger.kernel.org
Subject: Re: Serious performance regression in Wine applications and Linux
 2.6.24.*
References: <1206240595.9045.1243810639@webmail.messagingengine.com>
In-Reply-To: <1206240595.9045.1243810639@webmail.messagingengine.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kai wrote:
> Performance degrades by about 60% when I run Wine under any of the
> 2.6.24.* kernels. Attached are the output of lspci -vv and the two
> config files of each kernel.
>
> I upgraded to 2.6.24, back to 2.6.23.(not sure), then tried 2.6.24.1 and
> 2.6.24.3 and the issue is present in both; it's severe enough that Wine
> apps are virtually unusable for me with this version of the kernel; I'm
> having to use 2.6.23 until this somehow is resolved.
>
> I'd like some help figuring out why this performance regression exists,
> and what can be done to mitigate it.
>
> Please CC replies; I'm not on the list.
>   
This is strange, as my (two) Windows apps ran (and run) just fine under 
2.6.24 (and now under 2.6.25-rc6). Could you specify the applications 
you're having problems with?

David
