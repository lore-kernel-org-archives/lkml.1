Return-Path: <linux-kernel-owner+w=401wt.eu-S1764850AbYDVSg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764850AbYDVSg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbYDVSgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:36:08 -0400
Received: from proxy2.bredband.net ([195.54.101.72]:44103 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764271AbYDVSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:36:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmpHALjMDUhT48OPPGdsb2JhbACBUoZniRcBAQEBMJtA
Message-ID: <480E300A.3050905@coderworld.net>
Date: Tue, 22 Apr 2008 20:35:54 +0200
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: sboyce@blueyonder.co.uk
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2 (swap)partitions
 on a SATA drive]
References: <480C9B74.2060302@blueyonder.co.uk>
In-Reply-To: <480C9B74.2060302@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Has someone found the cause of this? I can't boot latest git as of 
today. I use ext3 if it's relevant. /dev/disk/by-id/ only shows my 
dvd-burner which is on pata. v2.6.25 is fine on this laptop.

regards, Richard
