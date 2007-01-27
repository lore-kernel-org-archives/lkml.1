Return-Path: <linux-kernel-owner+w=401wt.eu-S1751710AbXA0DsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbXA0DsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 22:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXA0DsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 22:48:10 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36269 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693AbXA0DsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 22:48:09 -0500
Message-ID: <45BACB71.2080107@lwfinger.net>
Date: Fri, 26 Jan 2007 21:48:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20060911)
MIME-Version: 1.0
To: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Hidden SSID's
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a convention regarding the information that a wireless MAC layer should provide when
reporting scan data from an AP with a hidden SSID?

In ieee80211, the software inserts the string "<hidden>" for such an AP, which seems to give
wpa_supplicant fits because it rejects the SSID before even looking at the encryption data. Is this
the normal convention?

Thanks,

Larry


