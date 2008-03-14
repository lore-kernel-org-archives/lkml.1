Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbYCNO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbYCNO6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 10:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYCNO6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 10:58:25 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:33267 "EHLO
	outbound6-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752399AbYCNO6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 10:58:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.22;Service: EHS
X-WSS-ID: 0JXQ6UM-01-RER-01
Date: Fri, 14 Mar 2008 15:56:06 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: panic caused by 653a00c9662304ef72a3eb4e681c91720960e0b4
	(ACPI:thermal fixup)
Message-ID: <20080314145606.GE22740@alberich.amd.com>
References: <20080314144559.GD22740@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080314144559.GD22740@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 14 Mar 2008 14:56:01.0311 (UTC) FILETIME=[84DB8AF0:01C885E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forget about it.

I've just pulled the current Linux tree and it seems to
contain already a fix for the problem (commit
c8d16e27a3601d1cbcdfe657eb4ff5e762019e8d).

I'll retest ...


Andreas


