Return-Path: <linux-kernel-owner+w=401wt.eu-S1762962AbYCWJLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762962AbYCWJLl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765341AbYCWImv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:42:51 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:10563 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765328AbYCWImr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:42:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NxnKKDunETyUr9XKhL9PFhuyItjmowQFHoeTdTujwc5bQ4rU1cRkwxz94sBvhl4EY+Jme6/ePgOKjN1l4Sv/T1YZjbbTtHF+HFqWy7Fp2gvtmt0AO5rzr3oexbD/bv9boPJl/QWm9g5OGYqnkIPZ7Zy8hcYohk2MW4LyeMuAUcA=
Message-ID: <84144f020803230142h4759f41dta75206386dbdd49b@mail.gmail.com>
Date: Sun, 23 Mar 2008 10:42:46 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
In-Reply-To: <20080322.162604.257163797.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	 <20080321.171401.49157146.davem@davemloft.net>
	 <84144f020803221557t36502f6bo327c95705be706bf@mail.gmail.com>
	 <20080322.162604.257163797.davem@davemloft.net>
X-Google-Sender-Auth: bf22b8449e2d3dba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, Mar 23, 2008 at 1:26 AM, David Miller <davem@davemloft.net> wrote:
>  Show how changing a version string can cause a regression for
>  a user.

It obviously can't but then again, we don't put comment or
documentation fixes in the stable tree either just because. But agreed
this is pointless now as Chris and Greg have explicitly said they're
ok.

                        Pekka
