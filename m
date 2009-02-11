Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbZBKMfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbZBKMfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756217AbZBKMfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:35:18 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:41004 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755805AbZBKMfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:35:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c7I1xr0hfEggYE0UqOGlMP77b/IWENSHH8kXuJD5aPCznEzc4OEYc0Lh2d9JwwFDkm
         HF5qDDtlLPC6Nccn9AryWCSe4/tM7L6RI+tXl+7Jh9Fg/lLRu1tdFFg5M5UDIBy8cnFH
         Jd1XuCe4/0r7wa2lUqGpk07N6mvD/gS/P1bh8=
MIME-Version: 1.0
In-Reply-To: <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
	 <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	 <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	 <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
Date: Wed, 11 Feb 2009 14:35:14 +0200
Message-ID: <46e1c7760902110435i2be8b7cex310de05e4fa3dcd2@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: adaplas@pol.net, linux-fbdev-devel@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can now confirm that the problem exists in 2.6.24, and the same
patch corrects it.

Risto
