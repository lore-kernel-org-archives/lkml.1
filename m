Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbYBRMoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbYBRMoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbYBRMoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:44:04 -0500
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42061 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751703AbYBRMoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:44:02 -0500
Date: Mon, 18 Feb 2008 13:43:54 +0100
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Quel Qun <kelk1@comcast.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Message-ID: <20080218124354.GA22045@Chamillionaire.breakpoint.cc>
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Quel Qun | 2008-02-18 00:01:21 [+0000]:

Please send me your .config file and process list (ps uax > ps_list)
after the crash. I have a dongle with the same usb id as yours and I
can't reproduce the crash. So it is either some .config magic or one of
your programs is accessing the dongle.

Sebastian
