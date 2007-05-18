Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXERWGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXERWGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 18:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXERWGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 18:06:34 -0400
Received: from 125.14.124.24.cm.sunflower.com ([24.124.14.125]:46987 "EHLO
	mail.atipa.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754995AbXERWGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 18:06:33 -0400
Message-ID: <464E2365.6060003@atipa.com>
Date: Fri, 18 May 2007 17:06:29 -0500
From: Roger Heflin <rheflin@atipa.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: BUG: sleeping function called from invalid context at mm/mempool.c:210
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 May 2007 22:09:05.0718 (UTC) FILETIME=[266EA560:01C79999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am getting this bug under heavy IO/NFS on 2.6.21.1.

BUG: sleeping function called from invalid context at mm/mempool.c:210

So far I have got the error I believe 3 times.

                   Roger
