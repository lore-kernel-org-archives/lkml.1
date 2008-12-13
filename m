Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYLMKXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYLMKXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 05:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbYLMKX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 05:23:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:31749 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYLMKX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 05:23:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oI7B0DEchVw1jZ5CVXYdAa5VSgZMsjs1CYYFZB4aBr3IiZ/0fQhfkS4A8o/giYFyZk
         uKhpzu6hd3HvW+KR+YFDLW7lxwRGGUlS8jzTRy2Rmn4A8OcEcBnq2Haj1o9jAiL7Oq78
         FTjMDqGYnR0NkgBry4Qn0c5kLC9LFBXirBgI4=
Message-ID: <e2e108260812130223q13fd98d8gc1e55881a92b939@mail.gmail.com>
Date: Sat, 13 Dec 2008 11:23:26 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: linux-iscsi-target-dev@googlegroups.com
Subject: Re: [Announce]: Target_Core_Mod/ConfigFS and LIO-Target v3.0 work
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1228965271.4153.510.camel@haakon2.linux-iscsi.org>
	 <e2e108260812111124j79793adcie106ac2da4f801f3@mail.gmail.com>
	 <1229025513.4153.542.camel@haakon2.linux-iscsi.org>
	 <e2e108260812112321w2f5b1827xe2593888e44808ae@mail.gmail.com>
	 <1229074809.4153.666.camel@haakon2.linux-iscsi.org>
	 <54939.1229149205@turing-police.cc.vt.edu>
	 <e2e108260812130141o3d21bbbdob9e7c9f95d309a74@mail.gmail.com>
	 <1229162907.4153.857.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 11:08 AM, Nicholas A. Bellinger <nab@kernel.org> wrote:
>> See also:
>> * February 1, 2008, LIO kernel panic during configuration,
>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/74c8b37f24b84e59/d94c07626bd20521?lnk=gst&q=kernel+panic#d94c07626bd20521.
>> * February 8, 2008, kernel crash triggered by LIO,
>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/30835aede1028188/5708e16a23367fb4?lnk=gst&q=kernel+crash#5708e16a23367fb4.
>> * February 13, 2008, LIO target kernel code triggers memory
>> corruption, http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/ddc1bf7666372972/2150a09f9ed3d1cd?lnk=gst&q=ipoib#2150a09f9ed3d1cd.
>> * February 18, 2008, LIO target makes entire system hang,
>> http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/6a76f9efd9409fc5/55bd8840b6a5f757?lnk=gst&q=lio+target+hangs#55bd8840b6a5f757.
>>
>
> I have no idea why why you keep bringing up a minor BUG (completely
> unrelated to Target_Core_Mod/ConfigFS and LIO-Target v3.0 btw) that was
> fixed 10 months ago..?  Perhaps if you spent half the time looking at
> actual lio-core-2.6.git code that you do bringing up minor closed bugs
> from months ago [ ... ]

I won't comment on the fact that you consider a kernel crash or a
system hang as a minor bug.

I reported four bugs instead of one. Only two of these have been
reported to be fixed.

Bart.
