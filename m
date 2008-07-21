Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYGUKzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYGUKzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbYGUKzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:55:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:59162 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbYGUKzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:55:04 -0400
Date: Mon, 21 Jul 2008 12:55:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Michael Kerrisk <mtk.manpages@gmail.com>
cc: aj@novell.com, Fabian Kreutz <kreutz@dbs.uni-hannover.de>,
       Andries Brouwer <Andries.Brouwer@cwi.nl>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: math_error.7 draft 3, for review
In-Reply-To: <517f3f820807210326x30ce95dayf18d72ba0ce03588@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0807211253190.21244@fbirervta.pbzchgretzou.qr>
References: <cfd18e0f0807160647o776d8523yb2f1ed4f0d946911@mail.gmail.com>  <cfd18e0f0807210314s6556f15bue41b1af46e28f77d@mail.gmail.com> <517f3f820807210326x30ce95dayf18d72ba0ce03588@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-07-21 12:26, Michael Kerrisk wrote:
>>  .SH DESCRIPTION
>>  On error, many of the mathematical functions declared in
>>  .IR <math.h>
>>  return a NaN (not a number).
>>  However, rather than looking at the return value

IMHO it looks easier (when directly editing the nroff file)
if you write it inline

	functions decalred in \fI<math.h>\fP return a NaN.
