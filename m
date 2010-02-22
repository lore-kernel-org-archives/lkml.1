Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0BVCXg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 21:23:36 -0500
Received: from mail-qy0-f175.google.com ([209.85.221.175]:49072 "EHLO
	mail-qy0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab0BVCXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 21:23:34 -0500
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 21:23:34 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uTJ4gLiGb1TEwtjcATVNV/WBRjv089OxWBpPd6FshmCPV4MPLwTlk7ULh6IHwR0jD7
         Px8STnpxVKLOta1kkOIaGnjfedp/Y8+KUs9ZTegac3t+B/FG3UV1gj9tqYdtKgC2zKD+
         Mj+W+N9hVCiNjji2GMBLwCSlMkJAaaB2nh/Z8=
MIME-Version: 1.0
In-Reply-To: <wj3ZQZlk_KB.A.Ye.iqagLB@chimera>
References: <4u4d-2M3yXH.A.XW.XqagLB@chimera> <wj3ZQZlk_KB.A.Ye.iqagLB@chimera>
Date: Sun, 21 Feb 2010 18:18:17 -0800
Message-ID: <dda83e781002211818s1b654266m9763a4d20e78ee3b@mail.gmail.com>
Subject: Re: [Bug #15309] reiserfs issue with 2.6.32.8
From: Bret Towe <magnade@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 1:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
>
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15309
> Subject         : reiserfs issue with 2.6.32.8
> Submitter       : Bret Towe <magnade@gmail.com>
> Date            : 2010-02-14 18:23 (8 days old)
> Message-ID      : <dda83e781002141023t2abe95b8w83f59d6f411f68a2@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=126617185512707&w=4
>
>

I'm still doing some bisecting trying to narrow down the problem
