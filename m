Return-Path: <linux-kernel-owner+w=401wt.eu-S932143AbYASBRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143AbYASBRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 20:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYASBR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 20:17:28 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:60647 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbYASBR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 20:17:28 -0500
Message-ID: <47914FA7.1000807@tlinx.org>
Date: Fri, 18 Jan 2008 17:17:27 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Known prob: MAX_LOCK_DEPTH too low?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my x86_64 machine, I got the following message
in log (kern = 2.6.23.14)

Jan 16 04:08:38 Astara kernel: BUG: MAX_LOCK_DEPTH too low!
Jan 16 04:08:38 Astara kernel: turning off the locking correctness 
validator.

Have no idea what caused it as I found the message on my console
somewhat after the fact.  The system had been up over 24 hours and
is still running.  System still seems 'fine' (been up 3 days now),
so you can treat this as a "data point".






