Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZBQO4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZBQO4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbZBQOz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:55:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:33379 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZBQOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:55:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SKzZkeXfYN2rezuN8J1cWF33FpeFNQUrIsnZPAkLuPzaGYEftVhvkEU7Mk10wudxtS
         yf//NO5LzHcE4n/3fh3R0osToEV3X7evz+uI6Ldg24gimIfr1lzPG/+daHNYxTYw+rX4
         +2ht9MDqDF0h22amjiG8BkLXjdKz1T7Er6HSs=
MIME-Version: 1.0
In-Reply-To: <20090217143251.GA1803@yoda.jdub.homelinux.org>
References: <D728AD1FA2543948B89DE29C5BF4CD0716AC2DDE@bjmail1.bj.datangmobile.com>
	 <76C7F485-EF75-4B83-B673-564E6243C7C6@kernel.crashing.org>
	 <20090217143251.GA1803@yoda.jdub.homelinux.org>
Date: Tue, 17 Feb 2009 22:55:55 +0800
X-Google-Sender-Auth: 9b3ab5758e2f0be3
Message-ID: <2a27d3730902170655nea2ae17x7186c4d8325b3778@mail.gmail.com>
Subject: Re: [PATCH] fix the interrupt loss problem on powerpc IPIC (2.6.23)
From: Li Yang <leoli@freescale.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: dayu@datangmobile.cn, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 10:32 PM, Josh Boyer <jwboyer@linux.vnet.ibm.com> wrote:
> On Tue, Feb 17, 2009 at 08:12:33AM -0600, Kumar Gala wrote:
>>
>> On Feb 17, 2009, at 6:44 AM, <dayu@datangmobile.cn> <dayu@datangmobile.cn
>> > wrote:
>>
>>> From: Da Yu <dayu@datangmobile.cn>
>>> Date: Tue, 17 Feb 2009 19:58:20 +0800
>>> Subject: [PATCH] fix the interrupt loss problem on powerpc IPIC
>>> (2.6.23)
>>>
>>> Signed-off-by: Da Yu <dayu@datangmobile.cn>
>>> ---
>>
>> Please provide a bit more description as to why this fixes the issue.
>
> Including whether it still applies to mainline, since your topic seems
> to indicate it's for 2.6.23.  That is pretty old by now.

The problem still exists in mainline.  But the patch doesn't seem to apply.

Dayu,

Could you re-spin the patch for the latest kernel?  Thanks.

- Leo
