Return-Path: <linux-kernel-owner+w=401wt.eu-S1764667AbYBWCrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764667AbYBWCrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 21:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbYBWCrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 21:47:32 -0500
Received: from senator.holtmann.net ([87.106.208.187]:52196 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbYBWCrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 21:47:31 -0500
Cc: linux-kernel@vger.kernel.org
Message-Id: <5BBCEBC1-EF90-4C17-9195-ADB9AA4DEB48@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Andy Shevchenko <andy@smile.org.ua>
In-Reply-To: <20080222174600.GT4909@serv.smile.org.ua>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] Add SDIO 'type' parameter to sysfs
Date: Sat, 23 Feb 2008 03:47:26 +0100
References: <20080222174600.GT4909@serv.smile.org.ua>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

> Add 'type' attribute of the SDIO device to represent Standard Function
> interface code in the human readable form.

these kind of things should not be part of the Linux kernel. A  
userspace tool (call it lssdio if you want) should handle it.

Regards

Marcel

