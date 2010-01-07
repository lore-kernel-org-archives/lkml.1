Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302Ab0AGAhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0AGAhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197Ab0AGAhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:37:19 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57829 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756195Ab0AGAhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:37:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W3mFe0TYNhiNw/JWce0P8e+Wj4RG2+lFBry0GmK6n84nyH3XQJv3rY9XnQDXiDgkuk
         sOuqA5WFfCWnntqIfzmSNfNJaAhLuZq9xqnMZn/ygwqufxJyLsycZyUF4FS88gnziomz
         vOOisc43lfXIg8mqX3dEoeP/YO920JoLpvFjY=
MIME-Version: 1.0
In-Reply-To: <20100106163113.637e47db.akpm@linux-foundation.org>
References: <E1NIuOW-0001ol-RC@dylan.lougher.demon.co.uk>
	 <20100106140409.ba0f63d1.akpm@linux-foundation.org>
	 <4B4528C8.3020603@lougher.demon.co.uk>
	 <20100106163113.637e47db.akpm@linux-foundation.org>
Date: Thu, 7 Jan 2010 00:37:15 +0000
Message-ID: <bffbecbb1001061637i31260775ja14523458cc1ed51@mail.gmail.com>
Subject: Re: [PATCH V2 6/8] lzma: Make lzma available to non initramfs/initrd 
	code
From: Phillip Lougher <phillip.lougher@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       linux-embedded@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, tim.bird@am.sony.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 12:31 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Your email client is doing space-stuffing.
>

Sorry, I was worried it might do that - the curse of Thunderbird.  I
normally use a
really dumb client like mailx to send patches, but I obviously didn't have the
email thread under mailx to do that.

If you want, I can resend the patch using my favourite dumb client.

Phillip
