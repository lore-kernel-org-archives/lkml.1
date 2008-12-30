Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbYL3M2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbYL3M2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbYL3M0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:26:50 -0500
Received: from lucidpixels.com ([75.144.35.66]:54662 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbYL3M0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:26:48 -0500
Date: Tue, 30 Dec 2008 07:26:48 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 2.6.28: Driver 'sd' needs updating - please use bus_type methods
Message-ID: <alpine.DEB.1.10.0812300615210.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have seen these for a few kernel versions now, is this related to 
generic scsi support?

[    0.368254] Driver 'sd' needs updating - please use bus_type methods
[    0.368320] Driver 'sr' needs updating - please use bus_type methods

