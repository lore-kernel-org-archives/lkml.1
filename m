Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbYCGQ5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbYCGQ5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 11:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbYCGQ5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 11:57:43 -0500
Received: from gw.goop.org ([64.81.55.164]:38882 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbYCGQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 11:57:42 -0500
Message-ID: <47D172A2.5000408@goop.org>
Date: Fri, 07 Mar 2008 08:51:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Tarkan Erimer <tarkan@netone.net.tr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux-2.6.25-rc4 (and also in rc3) Compile Error
References: <47CE6F66.7020004@netone.net.tr> <47D0895C.5070901@goop.org> <47D0F9D7.8010607@netone.net.tr>
In-Reply-To: <47D0F9D7.8010607@netone.net.tr>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tarkan Erimer wrote:
> Jeremy Fitzhardinge wrote:
>>
>> That doesn't make much sense.  Are you compiling with ARCH=xen or 
>> something?  I can't reproduce it here with your .config.
>>
>>    J
>
> Nope, I just selected the  "Processor type and features -> 
> Paravirtualized guest support" ( PARAVIRT_GUEST [=y] ) and all the sub 
> selections under this feature. When I compiled PARAVIRT_GUEST=n, it 
> compiles without any problem.

At what point does it fail?  Is it early in the build, or late?  What's 
your build command line?

    J
