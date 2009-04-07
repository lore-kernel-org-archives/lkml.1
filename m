Return-Path: <linux-kernel-owner+w=401wt.eu-S1754359AbZDGKCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbZDGKCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 06:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352AbZDGKC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 06:02:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35942 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZDGKC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 06:02:26 -0400
Date: Tue, 7 Apr 2009 13:02:23 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: 2.6.29-git13: Reported regressions from 2.6.28
In-Reply-To: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
Message-ID: <Pine.LNX.4.64.0904071256110.12253@wrl-59.cs.helsinki.fi>
References: <n4io5wq70ZO.A.gzG.rFn2JB@chimera>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12867
> Subject		: 2.6.29-rc7 broke r8169 MAC on Thecus n2100 ARM board
> Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> Date		: 2009-03-09 20:29 (29 days old)
> References	: http://marc.info/?l=linux-kernel&m=123663065403760&w=4
> Handled-By	: Francois Romieu <romieu@fr.zoreil.com>

I think this was fixed in the mainline by revert
ea8dbdd17099a9a5864ebd4c87e01e657b19c7ab.


-- 
 i.
