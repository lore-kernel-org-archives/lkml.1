Return-Path: <linux-kernel-owner+w=401wt.eu-S1752326AbXECJ1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbXECJ1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 05:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbXECJ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 05:27:15 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54461 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752274AbXECJ1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 05:27:14 -0400
Date: Thu, 3 May 2007 11:27:13 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>
cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: checkpatch, a patch checking script.
In-Reply-To: <20070503093225.10765f46@frecb000686.frec.bull.fr>
Message-ID: <Pine.LNX.4.62.0705031127010.29761@pademelon.sonytel.be>
References: <20070423141123.GA21174@skybase> <20070423104534.51bac974.akpm@linux-foundation.org>
 <20070425112133.4ae86399.randy.dunlap@oracle.com>
 <20070425143011.57247c1d.akpm@linux-foundation.org>
 <20070425172447.1576c399.akpm@linux-foundation.org> <20070426003911.GA19383@redhat.com>
 <4630109F.6090002@oracle.com> <20070425200207.77a2721a.akpm@linux-foundation.org>
 <20070428030805.GA13331@redhat.com> <Pine.LNX.4.62.0705021626080.3706@pademelon.sonytel.be>
 <20070503093225.10765f46@frecb000686.frec.bull.fr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584337861-1241859657-1178184433=:29761"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584337861-1241859657-1178184433=:29761
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 3 May 2007, [ISO-8859-1] Sébastien Dugué wrote:
> On Wed, 2 May 2007 16:28:27 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> 
> 
> > +		$warnings += search(qr/__FUNCION__/,
> 
>                                        ^__FUNCTION__ maybe?
> 
> > +			"Should use C99 __func__ instead of GNU __FUNCTION__\n");

Bummer... Of course!

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
---584337861-1241859657-1178184433=:29761--
