Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXF3QWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXF3QWt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbXF3QWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:22:40 -0400
Received: from gw.goop.org ([64.81.55.164]:45523 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbXF3QWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:22:39 -0400
Message-ID: <4686834E.1070800@goop.org>
Date: Sat, 30 Jun 2007 09:22:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc6-mm1
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>	<6150.1183128630@turing-police.cc.vt.edu>	<20070629140130.59d58c44.akpm@linux-foundation.org>	<15437.1183177066@turing-police.cc.vt.edu> <20070629221510.95c4c8e1.akpm@linux-foundation.org>
In-Reply-To: <20070629221510.95c4c8e1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> All my .configs have mouldered since I lost the ability to have .config be
> a symlink to a revision-controlled file (used to carry a custom patch for
> this, but it died).
>
> I continue to believe that kbuild's lets-trash-your-symlink behaviour is
> obnoxious, but I was unable to persuade anyone else of this.
>   

That's pretty awful, but it hasn't really affected me much since I 
started using separate object directories for pretty much everything.

    J
