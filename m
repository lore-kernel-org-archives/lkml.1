Return-Path: <linux-kernel-owner+w=401wt.eu-S1760977AbYF0NRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977AbYF0NRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 09:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYF0NRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 09:17:22 -0400
Received: from mx.sjtu.edu.cn ([202.112.26.52]:55460 "EHLO mx2.sjtu.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426AbYF0NRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 09:17:21 -0400
Message-ID: <20080627211712.6cto2d1zks848c88@webmail1.sjtu.edu.cn>
Date: Fri, 27 Jun 2008 21:17:12 +0800
From: =?gb2312?b?z8TBwQ==?= <xiaiaxaxi@sjtu.edu.cn>
To: linux-kernel@vger.kernel.org
Subject: How can I migrate a currently running task?
MIME-Version: 1.0
Content-Type: text/plain;
	charset=GB2312;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

       I am working on Intel Duo Core with Linux OS 2.6.21, and I'd  
like to migrate task from one cpu to another cpu.
In SMP systems, load_balance() function uses move_tasks() to move  
processes from source runqueue to local runqueue, but it does not move  
a currently running task. If I want to migrate a currently running  
task from source runqueue to local runqueue, how can I do? Any  
suggestion is preferred. Thanks!

     Liang

