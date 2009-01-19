Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZASOcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZASOcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:32:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZASOb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:31:57 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49137 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZASOb4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:31:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hm07GllNZcrAG/rr3K1Hl1MZfEKaizAeQHg5aHVuZn8jJ8yKRhheNrjJYNR9/bNyf4
         ZgMlejQuGbNZwOSQlzxMjmbTCUcNqMnQJohJTpMq54ckAg4alJ9IVH0ofzfJ6JfRskJq
         xV9y3Rb+hMXGYAANc9MU/OjqYq2qB5IBSzBtU=
MIME-Version: 1.0
In-Reply-To: <20090119141346.GA8258@hack.private>
References: <519a8b110901190604l4c248ea2n88a117a064c35fac@mail.gmail.com>
	 <20090119141346.GA8258@hack.private>
Date: Mon, 19 Jan 2009 15:23:34 +0100
Message-ID: <519a8b110901190623m7a4cfd98gf0ad33d248eb465c@mail.gmail.com>
Subject: Re: wrong sym link with out-of-tree build with 2.6.28
From: xming <xmingske@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 3:13 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:

> Please have a look at this thread:
>
> http://lkml.org/lkml/2008/8/15/166
>
> I think Sam explained there. Thanks.

Thanks, but what should we (as normal users) do? I can't build kvm
(not the in-kernel one)
with that wrong (non existent) sym link. Is that a problem that should
be fixed by kvm or
kernel devs?
