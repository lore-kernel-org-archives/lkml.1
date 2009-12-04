Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZLDOoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZLDOoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 09:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZLDOod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 09:44:33 -0500
Received: from lucidpixels.com ([75.144.35.66]:36580 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbZLDOod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 09:44:33 -0500
Date: Fri, 4 Dec 2009 09:44:39 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.32: scsi_wait_scan bug
Message-ID: <alpine.DEB.2.00.0912040943420.3540@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Checking the /lib/modules directory for 2.6.32, I noticed this bug still 
persists:
https://lists.linux-foundation.org/pipermail/bugme-new/2007-August/016634.html

Was wondering if it should be able to be enabled or disabled in the 
menuconfig (as you cannot currently see that option)?

Justin.
