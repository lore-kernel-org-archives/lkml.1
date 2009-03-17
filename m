Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbZCQQi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbZCQQi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756019AbZCQQip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:38:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:6504 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbZCQQio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:38:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vp1c6jNw6K+GIzTTQvy0VIImA6/DZp1J9mFuIYgVPQ230Znb7GXxh4kSAFV0hDuGlw
         1F4cqCHMAcuyfJ+i0SJqczVO/7x5mHblZc69CkTsFHfQg8jJWDxPtFa09OkvCnyFELDv
         NVreN7dyOYDSCFdUJJRrxyIK6hpyj5Qe5S6+c=
MIME-Version: 1.0
In-Reply-To: <e9e614960903170543p6117ce22qd0773d5a7cdd9977@mail.gmail.com>
References: <e9e614960903162141g2f272f82jee434fc6fc748544@mail.gmail.com>
	 <84144f020903162307x3d164432m4132b0dd1487bae@mail.gmail.com>
	 <20090317090322.GA24133@elf.ucw.cz>
	 <e9e614960903170543p6117ce22qd0773d5a7cdd9977@mail.gmail.com>
Date: Tue, 17 Mar 2009 09:38:42 -0700
X-Google-Sender-Auth: 29a4d148fcfaecfe
Message-ID: <84144f020903170938ya7cd939h474605796645feba@mail.gmail.com>
Subject: Re: w35und driver unusable
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: luoyi <luoyi.ly@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Sandro Bonazzola <sandro.bonazzola@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Mar 17, 2009 at 5:43 AM, luoyi <luoyi.ly@gmail.com> wrote:
> 2. rmmod w35und
>   modprobe w35und
>   Kernel Panic

Can you please post the exact oops so we can figure out what is going
on? Sandro, can you see this as well?
