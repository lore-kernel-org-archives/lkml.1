Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0CDSeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 13:34:17 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:40551 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab0CDSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 13:34:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=hazNtJJRV8NzqQ1KPQYfXzb++7Cb2uJa1JnrJZhtiGLAlThUCebZBKFSp1SPyHGJZc
         KnC8RqpLyvIBI/gar/3V0f3HcW6lkL0p3kle3mBs9lvOQ//7q5BYMcOo2N0LsjyzBzcz
         KL75LItcNvopPx3jFccGnMJTTr3wX5SrGLfn0=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
References: <alpine.DEB.2.00.1003022345100.4099@skynet.skynet.ie>
	 <alpine.LFD.2.00.1003041015080.3588@localhost.localdomain>
Date: Thu, 4 Mar 2010 13:27:33 -0500
Message-ID: <b4198de61003041027k6f4978a8xf8537328ee0ac9ed@mail.gmail.com>
Subject: Re: [git pull] drm request 3
From: Matt Turner <mattst88@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 4, 2010 at 1:18 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> but why the hell wasn't I made aware of it before-hand? Quite frankly, I
> probably wouldn't have pulled it.

>From Dave's initial pull request "[git pull] drm merge" from March 1,
he does say

> *NOTE* in case you missed it: this will *break* your nvidia machine, its purely
> intentional. Rawhide should have the libdrm and driver updates necessary.

Matt Turner
