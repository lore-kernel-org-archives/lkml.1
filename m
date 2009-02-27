Return-Path: <linux-kernel-owner+w=401wt.eu-S1756328AbZB0NtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328AbZB0NtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 08:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZB0NtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 08:49:11 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:9814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbZB0NtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 08:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=BwBc4P2K1R644qNeS//7ieF4dT+xLsEL9vwTu3Hrz6ChvE26beyNm3e9jwHqfrDRCX
         xRWiIjdjFzyJMU/CXRvWTwu0FhgmyACDsIuZeMYj7aS0v2r/Zu+SY13PDmIX6AMljqVf
         5Ufun7GZwFUzx2CUAzxb16zZDjCH+aBYdyGO4=
Message-ID: <49A7EF52.8080105@gmail.com>
Date: Fri, 27 Feb 2009 14:49:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: Andrew Morton <akpm@linux-foundation.org>, airlied@linux.ie,
       eric@anholt.net, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
References: <49A7B253.906@gmail.com> <20090227023231.76e7c65f.akpm@linux-foundation.org> <20090227130440.GA24633@silver.sucs.org>
In-Reply-To: <20090227130440.GA24633@silver.sucs.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.2.2009 14:04, Sitsofe Wheeler wrote:
> On Fri, Feb 27, 2009 at 02:32:31AM -0800, Andrew Morton wrote:
>> On Fri, 27 Feb 2009 10:28:51 +0100 Jiri Slaby<jirislaby@gmail.com>  wrote:
>>
>>> everytime I run X, it gets stuck. Currently running on mmotm
>>> 2009-02-26-16-58, but I think this is wider problem. I had i915 disabled
>>> for a long time (until I noticed today).
>
> Which version of X are you using? Does it support kernel modesetting? If
> not, did you disable kernel modesetting in the KConfig file for i915?

xorg-x11-server-7.4-17.3
which is
X.Org X Server 1.5.2

modesetting enabled:
CONFIG_DRM_I915_KMS=y

Which X version is needed for that?
