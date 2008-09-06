Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYIFPno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYIFPno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 11:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYIFPng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 11:43:36 -0400
Received: from japan.chezphil.org ([77.240.5.4]:5597 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYIFPnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 11:43:35 -0400
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Date: Sat, 06 Sep 2008 16:43:31 +0100
Subject: nice and hyperthreading on atom
Message-ID: <1220715811849@dmwebmail.dmwebmail.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Experts,

I have an ASUS Eee with an Atom processor, which has hyperthreading 
enabled.  If I have two processes, one nice and the other normal, they 
each get 50% of the CPU time.  Of course this is what you'd expect if 
the scheduler didn't understand that the two virtual processors are not 
really independent.  I'd like to fix it.

Google finds patches posted by Con Kolivas a looong time ago to address 
this.  Can anyone tell me what has happened in the meantime?  Maybe 
this feature is now in the kernel, but there's something I have to do 
to enable it (e.g. choose the right scheduler).  Or maybe it never made 
it in, for some reason.

Thanks for any suggestions.

Phil.



