Return-Path: <linux-kernel-owner+w=401wt.eu-S1752704AbZGAOe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbZGAOe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbZGAOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:34:10 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:45605 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbZGAOeI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:34:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vYujE1c3WTVPYOFpdHcJXe8rVRC/rlLQ+n2/mfbVFA3p5WE0/8nsFJT5LjOn1m4ZN+
         r/5kclEBnar9/KyJ9Nv++Jf+eC25roYOk5AuIUvWoL7eC7i4E8wrsV54ZVTRG0YAWigr
         x337QfIVwHNgj1XpdkdULDpa3253j6jDTfKHM=
MIME-Version: 1.0
In-Reply-To: <6JJ2m5kyucK.A.AtD.NJASKB@chimera>
References: <ij4ZQY4URcP.A.F3B.vIASKB@chimera>
	 <6JJ2m5kyucK.A.AtD.NJASKB@chimera>
Date: Wed, 1 Jul 2009 22:34:10 +0800
Message-ID: <b6a2187b0907010734w7e7a5bbfm271f44e57e12d1b4@mail.gmail.com>
Subject: Re: [Bug #13627] Tunnel device ignores TCP/UDP traffic
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>, Paul Martin <pm@debian.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 8:11 AM, Rafael J. Wysocki<rjw@sisk.pl> wrote:

> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13627
> Subject         : Tunnel device ignores TCP/UDP traffic
> Submitter       : Paul Martin <pm@debian.org>
> Date            : 2009-06-26 14:45 (3 days old)

I think I'm having the same issue here. Both vpnc and KVM (using tap0)
not working on 2.6.31-rc1. I think it worked before <2.6.30.

i've tried the patches as mentioned in
http://bugzilla.kernel.org/show_bug.cgi?id=13627, but still not
working.

Thanks,
Jeff.
