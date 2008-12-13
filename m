Return-Path: <linux-kernel-owner+w=401wt.eu-S1751738AbYLMQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbYLMQsR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 11:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYLMQsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 11:48:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58226 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYLMQsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 11:48:01 -0500
Date: Sat, 13 Dec 2008 16:47:52 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: [BUG] 2.6.27.8: Reboot fails after previous (^c on gthumb) bug
Message-ID: <20081213164752.GA31677@flint.arm.linux.org.uk>
References: <20081213164123.GB7639@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081213164123.GB7639@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might be related to the previous bug, or may not be.  Reboot wedged for
several minutes with the following as the last line:

sd 1:0:0:0: [sda] Synchronizing SCSI cache

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
