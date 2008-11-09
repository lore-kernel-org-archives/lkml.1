Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbYKIJE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbYKIJE4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 04:04:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYKIJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 04:04:36 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:4367 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYKIJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 04:04:35 -0500
Message-ID: <4916A751.4000104@chelsio.com>
Date: Sun, 09 Nov 2008 01:03:13 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 0/2 2.6.28] cxgb3 - driver fixes
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Nov 2008 09:04:35.0640 (UTC) FILETIME=[2FF57B80:01C9424A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

I’m submitting 2 patches for inclusion in 2.6.28.
Here is a brief description of the patch series:
- fix eeprom content access
- restrict multiqueue setting to MSI-X mode

Cheers,
Divy


