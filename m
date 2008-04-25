Return-Path: <linux-kernel-owner+w=401wt.eu-S933310AbYDYWeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933310AbYDYWeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbYDYWe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:34:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:5247 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbYDYWe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:34:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gaP6WROFHq3LT+AG7EKx4vdh4zNomsOgYBJznpoI2MMcUXtKWfy97M6iAGywquOYmoqZ0l97K5S5H75Sq7v7qCzlnVw+b488PHjVb4k/VAsy9+fTELJjihKXs0CqUwEJwNtadM2A31uDzWyWHLBFH+FQzjLVbdZDtnZREUIiP/M=
Message-ID: <9a8748490804251534q1ee865f7yd369fb22d515b83f@mail.gmail.com>
Date: Sat, 26 Apr 2008 00:34:22 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: can the 4KSTACKS selection be moved out from under kernel debugging?
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0804251821050.29563@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0804251821050.29563@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/2008, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
>
>   in the first place, it's already partially moved out anyway, since
>  x86 and SH define it as a debugging feature, while m68knommu doesn't.
>  more importantly, it simply isn't a debug feature and there's already
>  more than enough under the kernel debugging menu.
>

It would make a lot more sense to put it under "General setup" or
"Processor type and features" than keeping it under "Kernel hacking"
if you ask me...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
