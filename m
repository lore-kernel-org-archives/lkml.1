Return-Path: <linux-kernel-owner+w=401wt.eu-S936526AbXLQVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936526AbXLQVCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761614AbXLQVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:02:14 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:42322 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761350AbXLQVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:02:13 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18278.58314.892734.490418@stoffel.org>
Date: Mon, 17 Dec 2007 16:02:02 -0500
From: "John Stoffel" <john@stoffel.org>
To: "John Stoffel" <john@stoffel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: 2.6.24-rc5: tape drive not responding
In-Reply-To: <18278.55130.471797.398922@stoffel.org>
References: <18277.52079.718004.969358@stoffel.org>
	<20071217112551H.fujita.tomonori@lab.ntt.co.jp>
	<20071217031510.c3d500fd.akpm@linux-foundation.org>
	<18278.55130.471797.398922@stoffel.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just to confirm, the propsed patch to st.c fixes the issue with
2.6.24-rc5 as well at 2.6.24-rc5-mm1 with access to my DLT tape
drives.

Thanks!
John
