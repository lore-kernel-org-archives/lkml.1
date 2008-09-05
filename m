Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbYIEXWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbYIEXWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYIEXWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:22:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:49636 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbYIEXWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:22:43 -0400
Message-ID: <48C1BF41.8040404@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:22:41 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] x86: signal works for unification
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch series is for future unification of signal.c.
These patches make common functions similar in signal_32|64.c.

Could you please review them?

thanks,
Hiroshi Shimamoto
