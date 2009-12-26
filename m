Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZLZVeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZLZVeZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751703AbZLZVeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:34:24 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:43785 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZLZVeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=titem0GVU1y5/FkNqBok4X9qz8j1zPVwjyyguS7H3d6nc2oz/WNNvd3KzglBoO5CHy
         rsozDXdN2C8fmzDs144E3B6Y7e5ft9Sna14xv6ZGnOhN4JUBnLXuFbRWE1EwRy3HLl5P
         yqqb2gwiPcbLlzlYXUQxdROO40A7bOVNkwWYs=
MIME-Version: 1.0
In-Reply-To: <4B338F5B.9050904@windriver.com>
References: <1261653403.4937.192.camel@laptop> <4B338F5B.9050904@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 26 Dec 2009 16:34:02 -0500
Message-ID: <8bd0f97a0912261334m4f56b8taa0b46636e62923c@mail.gmail.com>
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       kdb@oss.sgi.com, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 10:57, Jason Wessel wrote:
> Peter Zijlstra wrote:
>> Please never post with kgdb-bugreport@lists.sourceforge.net
>> in the CC, it generates bounces for everything send to it.
>
> The kgdb-bugreports list has been fixed to cease the generation of
> non-subscriber notifications.  All you had to do was indicate there was
> a problem.  Non-subscribers are free to post there, and the messages go
> through a filter queue.

kgdb@oss.sgi.com needs fixing too it seems
-mike
