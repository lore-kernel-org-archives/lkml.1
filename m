Return-Path: <linux-kernel-owner+w=401wt.eu-S1756659AbYEQOkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659AbYEQOkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 10:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYEQOjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 10:39:55 -0400
Received: from main.gmane.org ([80.91.229.2]:57602 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102AbYEQOjy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 10:39:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: rt61pci breaks after hibernate
Date: Sat, 17 May 2008 14:39:36 +0000 (UTC)
Message-ID: <g0mqn8$56h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Cc: linux-wireless@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After resuming from a hibernate to disk network packets are no longer sent
and NetworkManager shows that there is no signal. Doing ifconfig wlan1
down && ifconfig wlan1 up results in the error message "SIOCSIFFLAGS: No 
such device" being printed.

-- 
Sitsofe | http://sucs.org/~sits/

