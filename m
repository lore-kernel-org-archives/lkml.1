Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbYGUPxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbYGUPxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYGUPxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:53:17 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:48236 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751783AbYGUPxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:53:16 -0400
Message-Id: <20080721030005.559625052@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 Jul 2008 05:00:05 +0200
From: zippel@linux-m68k.org
To: akpm@linux-foundation.org
Cc: johnstul@us.ibm.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] clocksource: CLOCK_MONOTONIC_RAW 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a resend of the raw monotonic clock patches. Compared to the
original patches I inserted a cleanup patch inbetween to keep the last
patch simple and to avoid the rounding issues, I dropped the fraction
completely, so that it becomes even simpler.

bye, Roman

-- 

