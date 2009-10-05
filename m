Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZJEKAE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZJEKAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:00:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758768AbZJEKAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:00:04 -0400
Received: from bosmailout14.eigbox.net ([66.96.184.14]:46445 "EHLO
	bosmailout14.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758767AbZJEKAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:00:03 -0400
X-Greylist: delayed 2500 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 06:00:03 EDT
X-EN-OrigOutIP: 10.20.18.4
X-EN-IMPSID: oxGP1c00105GATN0000000
Message-ID: <4AC9B97B.6070900@jaysonking.com>
Date: Mon, 05 Oct 2009 04:16:43 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Con Kolivas <kernel@kolivas.org>
Subject: [PATCH 0/4] BFS backport to 2.6.27
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.67.11.191
X-EN-OrigHost: adsl-67-67-11-191.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the finished backport of Con Kolivas' BFS to kernel 2.6.27.35.

There are four patches in this series that will be sent as replies to 
this email. The first three patches are mainline patches that change 
some scheduler accounting behavior. The fourth patch is the BFS 
backport. All patches should be applied in order on top of 2.6.27.35.

This port has been build- & run-tested on x86_64 only. If anyone finds 
problems related to this port, please let me know.

Jayson

