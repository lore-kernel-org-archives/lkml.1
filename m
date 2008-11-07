Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbYKGNZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbYKGNZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 08:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYKGNZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 08:25:42 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:26015 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbYKGNZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 08:25:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=sgkLa2FjYcolCXF4QyeI/fzk35Y152W+tC37W43Fui92r72DHXxkIgmFSqqenbUsK2
         LyWlxgSxzneKlBXgHfQvA0OO+oX61GgMXEWi9Zy+G+y9eTTZhjil+4VKnTqX24AZ3wO4
         Bk0uhV+HbakDZ1P3gXEP2sfyOBGY8KTsUtCQQ=
Message-ID: <5ff4a1e50811070525t56834306va8a975617de589b6@mail.gmail.com>
Date: Fri, 7 Nov 2008 13:25:41 +0000
From: "Matt Fleming" <mjf@gentoo.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: Allow section alignment
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu, rostedt@goodmis.org
In-Reply-To: <1226063896.2697.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ff4a1e50811070512v410e623ax60e8a65b169f800@mail.gmail.com>
	 <1226063896.2697.28.camel@twins>
X-Google-Sender-Auth: 3d1f3f85c4d2f200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/7 Peter Zijlstra <peterz@infradead.org>:
> On Fri, 2008-11-07 at 13:12 +0000, Matt Fleming wrote:
>> Provide a means of aligning the __mcount_loc section.
>
> Not that I object to the patch, but this changelog needs work.
>
> Its wrong, it doesn't provide means, it plain does.
> It doesn't tell us why.
>

Would you like me to resubmit the patch with a better changelog?
