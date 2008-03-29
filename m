Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbYC2UYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbYC2UYt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 16:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754333AbYC2UYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 16:24:41 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:46881 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbYC2UYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 16:24:40 -0400
X-Greylist: delayed 1254 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Mar 2008 16:24:40 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjNMAI497kdT48OPPGdsb2JhbACBWoZViQoBAQEBMJdL
Message-ID: <47EEA097.5000701@coderworld.net>
Date: Sat, 29 Mar 2008 21:03:35 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Keyboard weirdness: keys get stuck
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.25-rc6-git-something I have experienced stuck keys. When typing 
a  sentence a character repeats aboooooooout 10 times, or as 'about' 
above ;). I tested with a new kernel today, 2.6.25-rc7-git-something and 
the problem is still present.

With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel 
in between.

As a side note, timestamps gets mixed up in dmesg output in a 1-2 second 
span. Maybe related?

This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want 
configuration details or testing to be done.

regards, Richard
