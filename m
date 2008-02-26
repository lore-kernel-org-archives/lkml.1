Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbYBZVvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbYBZVvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763532AbYBZVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:50:50 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:39385 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762963AbYBZVus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:50:48 -0500
Date: Tue, 26 Feb 2008 22:38:14 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Chris Clayton" <chris2553@googlemail.com>
Cc: linville@tuxdriver.com, ivdoorn@gmail.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080226223814.4ef2b435@morte>
In-Reply-To: <c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	<200802252104.32416.chris2553@googlemail.com>
	<a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	<200802261911.39577.chris2553@googlemail.com>
	<20080226194838.GD3013@tuxdriver.com>
	<c6b1100b0802261313v12fb9cd5j6501e80f6d071019@mail.gmail.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.4.1.325704, Antispam-Engine: 2.6.0.325393, Antispam-Data: 2008.2.26.133303
X-PerlMx-Spam: No virus found, Gauge=IIIIII, Probability=26%, Report='RELAY_IN_PBL_11 2.5, SXL_IP_DYNAMIC 0.5, BODY_SIZE_300_399 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 21:13:48 +0000
"Chris Clayton" <chris2553@googlemail.com> wrote:

> And I will help in any way I can, providing diagnostics and trying patches.

Please, could you mount debugfs and provide me with a dump of this file:
/debug/ieee80211/phy*/stations/*/rc_pid_events

Thank you.


--
Ciao
Stefano
