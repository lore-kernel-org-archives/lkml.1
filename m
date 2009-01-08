Return-Path: <linux-kernel-owner+w=401wt.eu-S1754200AbZAHGf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbZAHGf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZAHGfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:35:15 -0500
Received: from nlpi042.sbcis.sbc.com ([207.115.36.71]:42544 "EHLO
	nlpi042.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZAHGfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:35:14 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2009 01:35:14 EST
Message-ID: <49659E41.5070001@softplc.com>
Date: Thu, 08 Jan 2009 00:33:37 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: New true IDE compact flash driver starting point?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a new ARM9 board with memory mapped interface to a compact flash 
socket, I need to implement an IDE or ATA driver that will support TRUE 
IDE mode.

Am using kernel version 2.6.26

What is the best starting point, i.e. example driver in the tree?


Please respond to my personal email address also as I do not subscribe.

TIA



