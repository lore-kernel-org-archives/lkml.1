Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbYDENt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbYDENt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYDENtt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:49:49 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:16515 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYDENts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:49:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=user-agent:date:from:to:cc:subject:message-id;
        b=AqyTkSkxYNUkxPZpYnk/CAzZtRtdFfYigOozLrt4XH6pymJLPTyvCRbugUuupfZCX8YBpOkcBeCX8dSKKF63gm1odjwtkMLy1ys8i8HJ3+GjUtB1yX6a4SN0XoojQTDTXHfaTkrFUMCtQfjzlp1395PKvkVYrH5v+/LOSv/iAuQ=
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:03 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 0/9] x86: cleanup patches
Message-ID: <47f7837a.0b0c360a.3214.ffffe4e7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is random collection of patch for x86.
Mainly each of patch attempts to clean up and increase readability of code.
-- 
