Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXAWOaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXAWOaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 09:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933004AbXAWOaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 09:30:35 -0500
Received: from il.qumranet.com ([62.219.232.206]:59926 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003AbXAWOae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 09:30:34 -0500
Message-ID: <45B61C09.5020501@qumranet.com>
Date: Tue, 23 Jan 2007 16:30:33 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/5] KVM fixes for 2.6.20
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of patches fixes several kvm problems.  I believe 
they are important and well-tested enough to be included in 2.6.20, 
especially the host reboot fix on AMD machines.

-- 
error compiling committee.c: too many arguments to function

