Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbYAHSA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbYAHSA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 13:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbYAHSAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 13:00:21 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:48440 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbYAHSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 13:00:20 -0500
Message-ID: <4783BA26.1090304@nortel.com>
Date: Tue, 08 Jan 2008 12:00:06 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: looking for help with mpt fusion driver log:  "FAULT code = 1804h"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jan 2008 18:00:10.0898 (UTC) FILETIME=[4FA93720:01C85220]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

We're seeing the following on startup:

Fusion MPT base driver 3.02.55
Copyright (c) 1999-2005 LSI Logic Corporation
Fusion MPT SAS Host driver 3.02.55
mptbase: Initiating ioc0 bringup
mptbase: ioc0: WARNING - IOC is in FAULT state!!!
            FAULT code = 1804h
mptbase: ioc0: ERROR - Failed to come READY after reset! IocState=0
mptbase: ioc0 NOT READY WARNING!
mptbase: WARNING - ioc0 did not initialize properly! (-1)
mptsas: probe of 0000:05:01.0 failed with error -1


Is this a disk fault or a host fault?  Can anyone identify what the 
specific fault code means, or point me to a suitable resource?

Thanks,

Chris
