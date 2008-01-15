Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbYAOV5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbYAOV5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbYAOV4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:56:49 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63095 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYAOV4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:56:48 -0500
Date: Tue, 15 Jan 2008 14:02:36 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/4] x86_64:amd fam10h mmconf v3
In-reply-to: <478CD46D.5080104@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Message-id: <200801151402.36271.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200801141331.45898.yinghai.lu@sun.com>
 <200801141336.35351.yinghai.lu@sun.com> <478CD46D.5080104@zytor.com>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the updated version, so we will not rely on MCFG setting

it is against to x86.git

these three patches can be applied seperately. 
if you think 2/4 is too complicated, you can apply 3 and 4

change: add msr in msr_index.h

Thanks

YH
