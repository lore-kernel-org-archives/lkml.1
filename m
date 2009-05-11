Return-Path: <linux-kernel-owner+w=401wt.eu-S1756702AbZEKOnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702AbZEKOnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZEKOmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:42:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:34832 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756376AbZEKOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qxCfZgn0CLhZ0p6mDDFm/cnZUuCsGrl86sIO8ETSinYKf6FbtuFByAoQV0dvuy8WnU
         5iAl+5OgG7pUc3bRp9GNMkXifIc6OnuSaWxF0WLb9hrm6kIgAohLW/dcmpRXSC6kzfg4
         4zSE2fg8oZvfaKBO4me3oyzkovmYOcbozleEU=
Date: Mon, 11 May 2009 22:43:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       util-linux-ng@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng v2.15 (stable)
Message-ID: <20090511144353.GA1134@hack>
References: <20090505214214.GC4460@nb.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505214214.GC4460@nb.net.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 11:42:14PM +0200, Karel Zak wrote:
>
>
>The stable util-linux-ng 2.15 release is available at
>
>   ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/
>
>Feedback and bug reports, as always, are welcomed.
>

I got:

...
gcc -std=gnu99 -DHAVE_CONFIG_H -I. -I..  -include ../config.h
-I../include -DLOCALEDIR=\"/usr/share/locale\"   -fsigned-char
-I/usr/include/blkid -I/usr/include/uuid    -g -O2 -MT mount-blkdev.o
-MD -MP -MF .deps/mount-blkdev.Tpo -c -o mount-blkdev.o test -f
'../lib/blkdev.c' || echo './'../lib/blkdev.c
mv -f .deps/mount-blkdev.Tpo .deps/mount-blkdev.Po
make[2]: *** No rule to make target fsprobe.c', needed by
mount-fsprobe.o'.  Stop.
make[2]: Leaving directory /home/wangcong/Projects/util-linux-ng/mount'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory /home/wangcong/Projects/util-linux-ng'
make: *** [all] Error 2

-- 
Live like a child, think like the god.
 
