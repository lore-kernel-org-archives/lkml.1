Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYBSAZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYBSAZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 19:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYBSAZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 19:25:44 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:56520 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYBSAZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 19:25:43 -0500
Message-ID: <47BA21F0.90405@pobox.com>
Date: Mon, 18 Feb 2008 19:25:20 -0500
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ballen@gravity.phys.uwm.edu, Ric Wheeler <ric@emc.com>
Subject: hdparm-8.2 now available
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hdparm for SATA/PATA has now been updated to version 8.2.
 
Upgrading is strongly recommended for all users.
This version fixes several bugs in earlier 7.x/8.x releases
that could cause issues when advanced features are attempted
on devices being driven by the old drivers/ide subsystem.

libata devices were unaffected, but drivers/ide devices could
misbehave or even be corrupted by some operations.

hdparm-8.2 is available at http://sourceforge.net/projects/hdparm/ 

Upgrading from any earlier 7.x or 8.x version
is strongly recommended for all users.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
