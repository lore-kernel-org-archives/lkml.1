Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYHDN1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYHDN1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYHDN1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:27:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:57541 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbYHDN07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:26:59 -0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-Id: <ABF9DC46-E821-4A2F-B55E-02217263E182@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
In-Reply-To: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v926)
Subject: Re: full list of unused CONFIGs under drivers/
Date: Mon, 4 Aug 2008 08:26:53 -0500
References: <alpine.LFD.1.10.0808031737280.16642@localhost.localdomain>
X-Mailer: Apple Mail (2.926)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3, 2008, at 4:38 PM, Robert P. J. Day wrote:

> ===== SERIAL_CPM_SCC1
> drivers/serial/Kconfig:1138:config SERIAL_CPM_SCC1
> ===== SERIAL_CPM_SCC2
> drivers/serial/Kconfig:1144:config SERIAL_CPM_SCC2
> ===== SERIAL_CPM_SCC3
> drivers/serial/Kconfig:1150:config SERIAL_CPM_SCC3
> ===== SERIAL_CPM_SCC4
> drivers/serial/Kconfig:1156:config SERIAL_CPM_SCC4
> ===== SERIAL_CPM_SMC1
> drivers/serial/Kconfig:1162:config SERIAL_CPM_SMC1
> ===== SERIAL_CPM_SMC2
> drivers/serial/Kconfig:1168:config SERIAL_CPM_SMC2

I'll take care of these.

thanks

- k
