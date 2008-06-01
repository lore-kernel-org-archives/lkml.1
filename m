Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYFAWKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYFAWKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 18:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYFAWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 18:10:45 -0400
Received: from hs-out-0708.google.com ([64.233.178.240]:15991 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYFAWKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 18:10:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=T7Lnud/V64/SVE50WkLHgmgzEeZa4wrwF2dAUjJMFfI9LWbdko5BqGZh6Z7/J3+X0s9lMIQc8ENef4j5byqFuO4LSZGa8rtlbxVf8kNBjcld+mXrOuzJIfKmVnPn6muzbo3zXwvKOGNAUx0CIACXcyaxvsk9/+Td6yRR5BeIndo=
Date: Sun, 1 Jun 2008 18:10:37 -0400
From: Joseph Fannin <jfannin@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: =?iso-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       geert@linux-m68k.org
Subject: Re: [PATCH] msdos fs: remove unsettable atari option
Message-ID: <20080601221035.GA9107@nineveh.local>
Mail-Followup-To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	=?iso-8859-1?Q?Ren=E9?= Scharfe <rene.scharfe@lsrfire.ath.cx>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, geert@linux-m68k.org
References: <1211717062.5782.16.camel@ubuntu> <87ve12s849.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ve12s849.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 12:42:29AM +0900, OGAWA Hirofumi wrote:
> René Scharfe <rene.scharfe@lsrfire.ath.cx> writes:
>
> > It has been impossible to set the option 'atari' of the MSDOS filesystem
> > for several years.  Since nobody seems to have missed it, let's remove
> > its remains.
> >
> > Signed-off-by: Rene Scharfe <rene.scharfe@lsrfire.ath.cx>
> > ---
>
> Looks good to me. Thanks.
>
> Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Geert Uytterhoeven has a patch in his POSTPONED queue that is supposed
to fix Atari FAT.  I can't speak to whether it works or why it's
postponed, but it seems to compile.

--
Joseph Fannin
jfannin@gmail.com

