Return-Path: <linux-kernel-owner+w=401wt.eu-S1761517AbXKAO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761517AbXKAO5m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 10:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761034AbXKAO5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 10:57:32 -0400
Received: from twin.jikos.cz ([213.151.79.26]:42339 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571AbXKAO5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 10:57:31 -0400
Date: Thu, 1 Nov 2007 15:57:24 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: =?ISO-8859-2?Q?Marcin_=A6lusarz?= <marcin.slusarz@gmail.com>
cc: linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: usbserial.ko/option.ko on 2.6.23: Unable to handle kernel paging
 request && inconsistent lock state
In-Reply-To: <4bacf17f0711010755w10f216f4lb059c181c76089ea@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711011556270.4152@twin.jikos.cz>
References: <4bacf17f0710291526l6be89bd9o33f02c33186d57b7@mail.gmail.com> 
 <Pine.LNX.4.64.0710300838280.18815@twin.jikos.cz> 
 <4bacf17f0711010259q52db983dqa7fc1f25e6a859d4@mail.gmail.com> 
 <Pine.LNX.4.64.0711011102090.4152@twin.jikos.cz>
 <4bacf17f0711010755w10f216f4lb059c181c76089ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1747641777-1430853947-1193929044=:4152"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1747641777-1430853947-1193929044=:4152
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 1 Nov 2007, Marcin =A6lusarz wrote:

> > What kernel version are you using? I should have already fixed this one=
 in
> > current git -- commit acd2a847
> I'm using 2.6.23

It got fixed after 2.6.24-rc1.

--=20
Jiri Kosina
---1747641777-1430853947-1193929044=:4152--
