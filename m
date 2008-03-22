Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbYCVVDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbYCVVDx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 17:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYCVVDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 17:03:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:64123 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbYCVVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 17:03:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:user-agent:date:from:to:cc:subject;
        b=DRqH6Z8YPkf7bst2n90M7B7o1RtodkhsgaVGWTw9t+no8syL+CbcW8mn7iLMzA06F5tiaFW9LqWtj2xsEngJRM+ooAqxfMbw7gjGijKqB8btsbbF78V7Y2lzYKNLNjziJyxfKQkVmPgZtIfqhizs5/a2oRV40JmXxhT2We0llas=
Message-Id: <20080322210005.117475478@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 23 Mar 2008 00:00:05 +0300
From: gorcunov@gmail.com
To: mingo@redhat.com
Cc: tglx@linutronix.de, hpa@zytor.com, gorcunov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [patch 0/4] x86 - relocate_kernel cleanup
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patches is to eliminate numeric constant and
use predefined macroses. Please review. I've tested 64bit version on
object level - it remains the same. Any comments are welcome.

		- Cyrill -

-- 
