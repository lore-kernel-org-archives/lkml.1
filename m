Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZHYUIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZHYUIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 16:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZHYUIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 16:08:23 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:22258 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755339AbZHYUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 16:08:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALvhk0pR9d7W/2dsb2JhbADZDwmEEQU
Date: Tue, 25 Aug 2009 22:08:22 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] txx9wdt.c:52: Fix txx9wdt_probe() cleaning up after
	errors
Message-ID: <20090825200822.GQ29382@infomag.iguana.be>
References: <4A93ACDA.8030000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A93ACDA.8030000@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roel,

> Make txx9wdt_probe() clean up after errors.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

patch added to the linux-2.6-watchdog-next tree.

Kind regards,
Wim.

