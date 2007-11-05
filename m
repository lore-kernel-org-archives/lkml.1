Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXKERLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXKERLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:11:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756970AbXKERHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:07:16 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59493 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757420AbXKERHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:07:13 -0500
Date: Mon, 5 Nov 2007 18:06:50 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Patrick Boettcher <pb@linuxtv.org>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
Subject: dib7000m_i2c_enumeration() is unused
Message-ID: <20071105170650.GF12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dib7000m_i2c_enumeration() is currently unused, but although I don't 
understand the code I have a gut feeling it should have been used in 
dib0700_devices.c. Is this correct?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

