Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZL3VQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZL3VQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 16:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZL3VQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 16:16:44 -0500
Received: from mail-px0-f189.google.com ([209.85.216.189]:40350 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZL3VQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 16:16:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=lK046SKqVnQOD1/mDEUVdOLFHPvobSOASQjrMQwtV+b4TeE5DgUP9NabcxnnHKU8Qr
         Esccia3XTZ+cV/n7PzMLfdEj6rA+g8NeF/VP1Ae2Vm0KcSc26/A38KmpW6DDSnSp6251
         fGC34KzbEozfnA6cWMPmVi7S1KFEicWYlX/J8=
References: <20091227214924.GB16279@core.coreip.homeip.net> <alpine.LFD.2.00.0912301257340.11961@localhost.localdomain>
Message-Id: <C08FBDE4-7143-46E4-9DB8-912E870D0008@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0912301257340.11961@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [git pull] Input updates for 2.6.33-rc2
Date: Wed, 30 Dec 2009 13:16:31 -0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Dec 30, 2009, at 12:58 PM, Linus Torvalds <torvalds@linux-foundation.org 
 > wrote:

>
>
> On Sun, 27 Dec 2009, Dmitry Torokhov wrote:
>>
>> 8 files changed, 84 insertions(+), 70 deletions(-)
>
> I get
>
> 14 files changed, 94 insertions(+), 96 deletions(-)
>
> so unpulled.
>
> If you updated your tree on purpose, you need to send me an email  
> saying
> so (preferably as a reply to your previous "please pull", so that  
> when I
> see the old one and it doesn't match what I get, I can then also see  
> the
> new one without having to search for it)

Yes, I just updated that branch with more fixes, not seeing any pulls  
after rc2 i thought you were gone till after New Year. I will resend  
updated pull request later tonight.

-- 
Dmitry

