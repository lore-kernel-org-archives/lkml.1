Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbYANVex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbYANVex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:34:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYANVdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:33:53 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55630 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYANVdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:33:49 -0500
Date: Mon, 14 Jan 2008 13:39:26 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH 0/3] x86_64:amd fam10h mmconf
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200801141339.27107.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check the updated version, so we will not rely on MCFG setting

it is against to x86.git

these three patches can be applied seperately. 
if you think 1/3 is too complicated, you can apply 2 and 3

Thanks

YH
