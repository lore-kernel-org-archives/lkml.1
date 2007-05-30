Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbXE3IMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbXE3IMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1749667AbXE3IMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:12:06 -0400
Received: from ihemail2.lucent.com ([135.245.0.35]:54254 "EHLO
	ihemail2.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbXE3IMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:12:05 -0400
Message-ID: <465D31D1.70508@alcatel-lucent.com>
Date: Wed, 30 May 2007 16:12:01 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Change IP TOS inside ethernet driver
References: <MDEHLPKNGKAHNMBLJOLKCEPKECAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKCEPKECAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2007 08:11:09.0928 (UTC) FILETIME=[14AEE680:01C7A292]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I want to change the IP TOS inside ioctl callback of ethernet driver, 
but don't know how to do this. Anybody has ideas?

Thanks in advance,
Gavin.
