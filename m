Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYJQRm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYJQRm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 13:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbYJQRmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 13:42:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60914 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754701AbYJQRmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 13:42:17 -0400
Date: Fri, 17 Oct 2008 18:41:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bryan Wu <cooloney@kernel.org>
Cc: alan@redhat.com, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH 1/9] Blackfin Serial Driver: updates kgdb over Blackfin
 serial driver with kgdb framework
Message-ID: <20081017184155.4143a88a@lxorguk.ukuu.org.uk>
In-Reply-To: <1224179047-13073-2-git-send-email-cooloney@kernel.org>
References: <1224179047-13073-1-git-send-email-cooloney@kernel.org>
	<1224179047-13073-2-git-send-email-cooloney@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous set are already merged/reviewed in the ttydev tree (barring
the cpu_relax mystery item) so I'd much rather get patches versus the
ttydev tree so I can see what has actually changed this time not
re-review the entire collection again.

Alan
