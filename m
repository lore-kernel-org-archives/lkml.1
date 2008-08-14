Return-Path: <linux-kernel-owner+w=401wt.eu-S1758446AbYHNSJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758446AbYHNSJZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHNSJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:09:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:19138 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbYHNSJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:09:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=x9jOKRv4m190tPU7zahMzYxQGLqPtRc9kDcSCgPQOw1yv1AVXGhEmxA+azMJAMvLR3
         QzRYX/7WgXtRk/gR0FN18ch8vvz3KtHmXXM7ZjBDQ4dpwJgMImEaAQWHNVnzp3LFSJ3Z
         wbi77xUeUS9ns1iY0AecHq/Ur4zeYC0Eyr8yc=
Message-ID: <1ba2fa240808141109l11d729ecjf6253e9acf5d3c7f@mail.gmail.com>
Date: Thu, 14 Aug 2008 21:09:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Will Simoneau" <simoneau@ele.uri.edu>
Subject: Re: [ANNOUNCE] Wifi Link 5300 and 5100 Series
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ipw3945-devel@lists.sourceforge.net, "Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <20080814175532.GB30317@ele.uri.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1ba2fa240808131411o638311f1m2e2daa6ef62057b1@mail.gmail.com>
	 <20080814062604.GA16234@ele.uri.edu>
	 <1ba2fa240808140515r92a3ec7i90ea6c03e2adb7ee@mail.gmail.com>
	 <1ba2fa240808140603p3b4a47e4k4a0b98e5bf145b57@mail.gmail.com>
	 <20080814175532.GB30317@ele.uri.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 8:55 PM, Will Simoneau <simoneau@ele.uri.edu> wrote:
> On 16:03 Thu 14 Aug     , Tomas Winkler wrote:
>> On Thu, Aug 14, 2008 at 3:15 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>> > On Thu, Aug 14, 2008 at 9:26 AM, Will Simoneau <simoneau@ele.uri.edu> wrote:
>> >> On 00:11 Thu 14 Aug     , Tomas Winkler wrote:
>> >>> Intel would like to announce Linux support  for Wifi Link 5000 and
>> >>> 5100 Series Adapters under iwlwifi driver (iwlagn.ko)
>> >>>
>> >> ...
>> >>> The best known working driver can be located in iwl500 branch of
>> >>> iwlwifi-2.6.git
>> >>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git iwl5000
>> >>
>> >> This is great news to me - my new Sager laptop has a 5300 card. However,
>> >> it doesn't seem to work:
>> >>
>>
>> Can you send me the exact laptop type?
>> Thanks
>
> It's a Sager NP5796 (Clevo M570TU).
>

>git-checkout -b iwl5000 origin/iwl5000
Tomas
