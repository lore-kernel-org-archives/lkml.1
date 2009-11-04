Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbZKDQxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbZKDQxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756329AbZKDQxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:53:13 -0500
Received: from lucidpixels.com ([75.144.35.66]:43638 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372AbZKDQxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:53:13 -0500
Date: Wed, 4 Nov 2009 11:53:18 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel Options: To use MSI-X or not?
Message-ID: <alpine.DEB.2.00.0911041151410.17867@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I was curious whether its best to use MSI-X when the driver supports it or 
not?

Example, 3ware cards/Intel Audio Drivers you can use MSI-X instead of 
having several devices use/share an interrupt.

What are the pros/cons to using MSI-X vs. having devices share an IRQ?

Justin.
