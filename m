Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbXL2A4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbXL2A4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 19:56:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXL2A4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 19:56:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:3458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbXL2A4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 19:56:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NYsfZuoQL69PaN+EEi2pAFoqQ8b6u1vL95TGVzHVPJHgih5f2HzGZEuLtEym35McU3lJWXKrKnMzfK0Wl/tNdtyuKAY11Qt3zTxV2T4oCCUPg7ErCPVeCd/3IqHh3f5SBMlzs+eotv/5bj1cM5QwU74gCrSSBQ1O7cBOuZjfLwM=
Date: Sat, 29 Dec 2007 09:00:18 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/12][RFC] Use mutex instead of semaphore in driver core
Message-ID: <20071229010018.GA2883@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

The semaphore use in driver core could be changed to mutex. These patches are based on 2.6.24-rc6-mm1 and can build on my pc. 

Regards
dave
