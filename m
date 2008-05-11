Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYEKRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYEKRnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 13:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYEKRnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 13:43:09 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49985 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753755AbYEKRnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 13:43:08 -0400
Message-Id: <20080511173653.869192035@sortiz.org>
User-Agent: quilt/0.46-1
Date: Sun, 11 May 2008 19:36:53 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/5] ASIC3 updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

This is a 5 ASIC3 patches set for:

- Adding ASIC3 gpiolib support.
- Improving the configuration code.
- Removing the children device registration.
- Improving code style.

Cheers,
Samuel.
