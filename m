Return-Path: <linux-kernel-owner+w=401wt.eu-S1757053AbYKEU65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053AbYKEU65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbYKEU6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:58:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:4303 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbYKEU6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:58:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Z7qNTooKvQKyKOlB0z+JbeSD5dnznsAA1uziSRL9OVI9XqIDD3uHLJKVLc4yulFwdm
         0YF6GlU3bRjnlG7An5g0/HDztxV077NRov9xii/5Dpi8kbdzeb+/WqjgeEMna7D5kCqq
         qbqsFrl6iSTFli3DQTqAhIZ7DcF/RQCyubzGc=
Message-ID: <cd73a99e0811051258v7c5c8bd8qf82f4e5a81068c85@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:58:45 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] SAM9 watchdog - supported on all SAM9 and CAP9 processors
Cc: wim@iguana.be, linux-kernel@vger.kernel.org
In-Reply-To: <20081105124543.7679a313.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cd73a99e0811051236x3c852ce7w5d16a695d8efb9c6@mail.gmail.com>
	 <20081105124543.7679a313.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Andrew,

> I queued your sam9-watchdog-update-for-moved-headers.patch for
> immediate mainline merge by myself.
>
> I queued this patch
> (sam9-watchdog-supported-on-all-sam9-and-cap9-processors.patch) for
> sending to Wim with a for-2.6.28 suggestion.

Thanks.


> sylpheed mucks that up.  text/plain attachments would be preferred,
> please.  Inlined non-wordwrapped, non-tab-replaced, non-space-stuffed
> text would of course be even better.

Unfortunately, gmail seems to mess up (ie, corrupt the whitespace of)
the inlined patches.
Maybe if I drop the ".patch" extension or use ".txt" it won't set the
content-type to text/x-patch.  Will try that next time.


Regards,
  Andrew Victor
