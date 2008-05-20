Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbYETUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbYETUIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758538AbYETUIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:08:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34498 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758436AbYETUID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:08:03 -0400
Date: Tue, 20 May 2008 22:07:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: matthias@kaehlcke.net
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [patch 0/2] i2c-core.c: use list_for_each_entry_safe()
Message-ID: <20080520220744.3433cf81@hyperion.delvare>
In-Reply-To: <20080519204838.612046856@kaehlcke.net>
References: <20080519204838.612046856@kaehlcke.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2008 22:48:38 +0200, matthias@kaehlcke.net wrote:
> i2c-core.c: use list_for_each_entry_safe() in i2c_del_adapter() and i2c_del_driver()

Applied, thanks.

-- 
Jean Delvare
