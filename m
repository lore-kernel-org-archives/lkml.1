Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbZKKMS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbZKKMS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 07:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbZKKMS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 07:18:58 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64281 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZKKMS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:18:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=JUn2E0hV6Z0jGgxqJnUIM/gg2GSorIDfSgvUnSnK7kRf3yuBUp0r5C1g0i/i7azft0
         oKhnfUH9jCRWX7/ixYj2WNQCYUfJdJ41oyeK8iVUSIFXxaT/FGqEYfff+vFS++rJsWxN
         jSFaCYeUSDwcoky0ql4ghMfX2aGMMaCcLuNGE=
MIME-Version: 1.0
In-Reply-To: <20091110162955.68321ab9.akpm@linux-foundation.org>
References: <1257428794-9203-1-git-send-email-tfransosi@gmail.com>
	 <c0c067900911101609v5ca52bb1h98a7bde2cf625ad@mail.gmail.com>
	 <20091111001100.GA14329@suse.de>
	 <20091110162955.68321ab9.akpm@linux-foundation.org>
Date: Wed, 11 Nov 2009 10:19:01 -0200
Message-ID: <a4c8a6d00911110419u518fa8d2k94032875221e5e91@mail.gmail.com>
Subject: Re: [PATCH] drivers/serial: remove BAUD_TABLE_SIZE macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Harik <harik.attar@gmail.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:29 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> I got it.

Thanks Andrew, sorry for the confusion about cc'ed people, that was
because get_maintainer.pl does not return anyone, so I didn't know who
should be copied. But will pay more attention on this next time.
