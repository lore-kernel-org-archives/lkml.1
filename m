Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab0BKXA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:00:28 -0500
Received: from lucidpixels.com ([75.144.35.66]:44508 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab0BKXA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:00:26 -0500
Date: Thu, 11 Feb 2010 18:00:23 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-raid@vger.kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Linux mdadm superblock question.
Message-ID: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I may be converting a host to ext4 and was curious, is 0.90 still the only 
superblock version for mdadm/raid-1 that you can boot from without having 
to create an initrd/etc?

Are there any benefits to using a superblock > 0.90 for a raid-1 boot 
volume < 2TB?

Justin.
