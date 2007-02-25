Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXBYAmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXBYAmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932854AbXBYAmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:42:50 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:17873 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932853AbXBYAmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:42:49 -0500
Message-ID: <45E0DB6A.2020909@chelsio.com>
Date: Sat, 24 Feb 2007 16:42:18 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/7 RESEND] cxgb3 - Chelsio T3 1G/10G driver updates
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2007 00:42:22.0284 (UTC) FILETIME=[CFBA00C0:01C75875]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I'll be resending the series of incremental patches originally submitted 
on 02/22/07.

The series take in account Yoshifuji's comments.
Patch 2 - ioctl cleanup - is updated to secure backward compatibility.
The ioctls are now explicitly numbered.
Patch 6 is also updated with minor changes:
some comments are modified /* .. */  instead of // ..

The other patches remain unchanged.

Cheers,
Divy
