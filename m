Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbYD1SLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbYD1SLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965364AbYD1SKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:10:50 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:64205 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965308AbYD1SKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:10:47 -0400
Message-ID: <48161325.1080508@ct.jp.nec.com>
Date: Mon, 28 Apr 2008 11:10:45 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: [PATCH -rt 0/4] nmi_watchdog fixes for -rt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a patchset of nmi_watchdog fixes for -rt kernel.
These patches are against 2.6.24.4-rt4.
Could you please review?

thanks,
Hiroshi Shimamoto
