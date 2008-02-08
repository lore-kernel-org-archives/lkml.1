Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbYBHI1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbYBHI1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 03:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761277AbYBHI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 03:27:28 -0500
Received: from smtp.nokia.com ([192.100.105.134]:34645 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078AbYBHI11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 03:27:27 -0500
Message-ID: <47AC1205.5070907@nokia.com>
Date: Fri, 08 Feb 2008 10:25:41 +0200
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: UBI: add mtd_num sysfs attribute
References: <200802071907.m17J7eYA022058@hera.kernel.org> <20080208054743.GA13097@kroah.com>
In-Reply-To: <20080208054743.GA13097@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Feb 2008 08:27:21.0310 (UTC) FILETIME=[6C9887E0:01C86A2C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> Can you please add this information to Documentation/ABI/ so that people
> know what is going on here?

Sent you the patch (Subject: [PATCH] Documentation: add UBI sysfs ABI docs).
I assume you'll put it into your tree and take the further care of it, right?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
