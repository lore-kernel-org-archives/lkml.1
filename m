Return-Path: <linux-kernel-owner+w=401wt.eu-S1946469AbXBCPB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946469AbXBCPB4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:01:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946468AbXBCPB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:01:56 -0500
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:33207 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946467AbXBCPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:01:55 -0500
Date: Sat, 3 Feb 2007 16:01:53 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Disabling Flow Control doesn't fix the problem for me.
Message-ID: <20070203150153.GB2178@cip.informatik.uni-erlangen.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11-2006-07-11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,
I just want to let you know, that you last patch on lkml, doesn't fix
the problem for me. But I think we tried that before with ethtool (not
as a kernel patch). However with my watchdog I can live at the moment.

        Thomas
