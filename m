Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbYFVVOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbYFVVOp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756163AbYFVVOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:08 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57491 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756085AbYFVVOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:07 -0400
Message-Id: <20080622211247.734979275@fluff.org.uk>
User-Agent: quilt/0.46-1
Date: Sun, 22 Jun 2008 22:12:47 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: linux-kernel@vger.kernel.org
Cc: arnaud.patard@rtp-net.org, akpm@linux-foundation.org
Subject: [patch 0/4] SM501 MFD driver updates for next kernel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of SM501 MFD driver updates for the next
kernel release.

Note, there is an patch offset of -2 lines in the
include/linux/sm501.h due to changes in patches currently
sent to the fbdevel list. If akpm can merge those first,
then this series should then apply cleanly.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
