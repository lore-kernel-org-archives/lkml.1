Return-Path: <linux-kernel-owner+w=401wt.eu-S1945951AbXEAVur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945951AbXEAVur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 17:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945992AbXEAVur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 17:50:47 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:8516 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945976AbXEAVup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 17:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bf+GaJ2RUZYsryEn0n7tQ8mzUyzbyVqaVrMlsnivzUQv02IbyS2y5GYrVZX0OHPwUca3tJpQ6YvmSCCvXKFhXza28Tk4ElAq114rZNU1GTCdmYUuFAaLRlGK2tsGgKdIACULiDJRX2wi2iqDX+NQ37IEvCnPcGGpv+bx6420GTw=
Subject: Re: [patch 05/33] m68k: Atari fb revival
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <20070501203330.469191361@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
	 <20070501203330.469191361@mail.of.borg>
Content-Type: text/plain
Date: Wed, 02 May 2007 05:50:37 +0800
Message-Id: <1178056237.4606.19.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-01 at 22:32 +0200, Geert Uytterhoeven wrote:
> plain text document attachment (636-atafb.diff)
> From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
> 
> Update the atari fb to 2.6 by Michael Schmitz,

Finally :-). That leaves only pm3fb that needs porting.

It still contains remnants of 2.4 code though, ie, FBCON_HAS_*, but
that's minor.

> Reformatting and rewrite of bit plane functions by Roman Zippel,
> A few more fixes by Geert Uytterhoeven.
> 
> Signed-off-by: Michael Schmitz <schmitz@debian.org>
> Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Antonino Daplas <adaplas@gmail.com>

Tony


