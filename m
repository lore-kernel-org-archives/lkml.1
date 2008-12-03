Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYLCQnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYLCQnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbYLCQnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:43:24 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:43042 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYLCQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:43:23 -0500
Subject: sshd segmentation fault on ia64 on 28-rc7-mmotm-081203
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-netdev@vger.kernel.org,
       linux-ia64 <linux-ia64@vger.kernel.org>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 03 Dec 2008 11:43:20 -0500
Message-Id: <1228322600.6693.61.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I couldn't find anything on the list about this.

I've built and booted 28-rc7-mmotm-081203 on both x86_64 and ia64.  I
can ssh into the x86_64 platform fine.  On the ia64, I'm seeing sshd
[from RHEL5 distro] seg faulting.  [Same sshd worked on the
28-rc6-mmotm-081201 kernel.]

Has anyone else seen this?

Lee

