Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYCORYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYCORYY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbYCORYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:24:17 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:33683 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbYCORYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:24:16 -0400
Date: Sat, 15 Mar 2008 18:23:16 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: =?UTF-8?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/5] cleanups ntp.c (from Ingo)
In-Reply-To: <47DB97BA.3080109@web.de>
Message-ID: <Pine.LNX.4.64.0803151817480.1791@scrub.home>
References: <1205553852.6122.76.camel@localhost.localdomain> 
 <1205553938.6122.79.camel@localhost.localdomain>  <1205554018.6122.81.camel@localhost.localdomain>
 <1205554210.6122.85.camel@localhost.localdomain> <47DB97BA.3080109@web.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-1823744743-1205601796=:1791"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-1823744743-1205601796=:1791
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Sat, 15 Mar 2008, J=F6rg-Volker Peetz wrote:

> Since you are at it, isn't "time_adj" a poor name since you also have a
> "time_adjust"?

These are two different (and independent) mechanism to adjust time. The=20
names are a little confusing, but I'd be a little reluctant to rename=20
time_adj, as the same name is used in the reference implementation.

bye, Roman
---1463811837-1823744743-1205601796=:1791--
