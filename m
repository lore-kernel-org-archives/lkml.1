Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935620Ab0CMTgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:36:25 -0500
Received: from mail-iw0-f176.google.com ([209.85.223.176]:39942 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935476Ab0CMTgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:36:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=q1optY1sjt85YxwlevxsQ2EOtKhWZReuErKoAwKSX1azHezlOweIlzTySLa2FNqVB4
         ORS0Yx8x5Sn8HdMJFiirlMbNQBixbg5+Zz6ZoPI6t7avbhL2RrY2IDBvD+BteovQVQ6Q
         Vv/80EDxO+bapQt5IKxghZGSn2ReRcPP1I4RU=
MIME-Version: 1.0
In-Reply-To: <1268418441.2802.61.camel@mulgrave.site>
References: <1268242604.22601.25.camel@mulgrave.site> <alpine.LFD.2.00.1003121008420.3719@i5.linux-foundation.org> 
	<1268418441.2802.61.camel@mulgrave.site>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Sat, 13 Mar 2010 11:35:59 -0800
X-Google-Sender-Auth: 2498aba4f791670d
Message-ID: <2c0942db1003131135m1bea386dx4dd7990832cfbfea@mail.gmail.com>
Subject: Re: [GIT PULL] final scsi updates for 2.6.34-rc1
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 10:27 AM, James Bottomley wrote:
> I do always have a tree ready in the first days of the merge window.  It
> was, in fact, here:

[...]

> The slight problem is that I accumulate updates (like almost everyone
> else) from the few days before the merge window opened up until about
> the middle of the second week.  That's what goes into the final pull,
> plus assorted bug fixes that showed up during the window.

You appear to being using git as a sort of baroque CVS. Fixes that
arrive after the beginning of the merge window should be put into a
separate branch other than the one ready for submission. Features that
arrive after the beginning of the merge window should be placed into
yet another branch destined for the next merge window.
