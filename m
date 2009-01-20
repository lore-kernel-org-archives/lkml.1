Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZATBqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZATBqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760455AbZATBqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:46:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:24130 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760102AbZATBqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W4K85oxbJrbzOUZyOKtbExx0Lv5w20mQdyshXbhzclkdSSblrra/UbLUgntqAQenRS
         V2OY8QDS2p45F3OPo2XBjWVweY2E3qEE/q8eT2jpwXTKfqridj4joLwJe5/akQb7yWYu
         bUxjgLxEakGLzYTFyev03LwX/ZMtnfFQJxx0M=
MIME-Version: 1.0
In-Reply-To: <20090119152104.GC6432@c2.user-mode-linux.org>
References: <20090115194033.GA10926@hack.private>
	 <20090116124158.4364e269.akpm@linux-foundation.org>
	 <200901170328.15178.rob@landley.net>
	 <dc84318c0901172223p57872a8cr227d940b1c0a908a@mail.gmail.com>
	 <20090119152104.GC6432@c2.user-mode-linux.org>
Date: Tue, 20 Jan 2009 09:46:15 +0800
Message-ID: <dc84318c0901191746g31d51c23g65da89190dc8bfd2@mail.gmail.com>
Subject: Re: [uml-devel] [Patch] uml: fix a link error
From: Daolong Wang <ahlongxp@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Rob Landley <rob@landley.net>, user-mode-linux-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       "Am?rico Wang" <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 11:21 PM, Jeff Dike <jdike@addtoit.com> wrote:
> On Sun, Jan 18, 2009 at 02:23:46PM +0800, Daolong Wang wrote:
>> I can confirm this link error.
>
> In what environment?  I see no problems here.
>
Ubuntu 8.04. Gcc is 4.2.4. Sorry I don't have the access to the machine now.
>> And this patch works for me.
>
> Maybe it fixes the link failure.  But I really doubt that sigprocmask works.
>
not sure. compile test only!
>                                Jeff
>
> --
> Work email - jdike at linux dot intel dot com
>
