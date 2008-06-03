Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbYFCQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbYFCQQS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYFCQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:16:10 -0400
Received: from panic.printk.net ([217.147.83.20]:33551 "EHLO panic.printk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYFCQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:16:09 -0400
Subject: Re: [PATCH 4/7] disable broadcomm legacy boot interrupt generation
From: Jon Masters <jonathan@jonmasters.org>
To: Olaf Dabrunz <od@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Stefan Assmann <sassmann@suse.de>
In-Reply-To: <12124107072891-git-send-email-od@suse.de>
References: <12124107071847-git-send-email-od@suse.de>
	 <12124107072891-git-send-email-od@suse.de>
Content-Type: text/plain
Date: Tue, 03 Jun 2008 11:46:43 -0400
Message-Id: <1212508003.22357.8.camel@londonpacket.bos.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 14:45 +0200, Olaf Dabrunz wrote:

> Add a quirk to disable legacy boot interrupt generation on broadcomm HT1000.

This one interests me, because I got access to the Broadcom HT-1000
datasheet and could not find this feature mentioned in there. I'd
appreciate knowing how you figured this one out :)

Jon.


