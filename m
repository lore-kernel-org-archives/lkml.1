Return-Path: <linux-kernel-owner+w=401wt.eu-S1760188AbXKHMaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760188AbXKHMaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 07:30:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbXKHMaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 07:30:06 -0500
Received: from smtp2e.orange.fr ([80.12.242.112]:13512 "EHLO smtp2e.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364AbXKHMaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 07:30:05 -0500
X-ME-UUID: 20071108123001696.AA0CB70000E6@mwinf2e12.orange.fr
Date: Thu, 8 Nov 2007 13:25:20 +0100
From: Philippe Elie <phil.el@wanadoo.fr>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: oprofile-list@lists.sourceforge.net, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] AVR32: Oprofile support
Message-ID: <20071108122520.GC2889@zaniah>
References: <1194444333-9264-1-git-send-email-hskinnemoen@atmel.com> <20071108092806.GB2889@zaniah> <20071108121413.4919e4a3@siona>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108121413.4919e4a3@siona>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Nov 2007 at 12:14 +0000, Haavard Skinnemoen wrote:

> > Why not a loop here ?
> 
> The system register is coded into the instruction as an immediate, so
> it would have to be a loop with a switch in it. And with only three
> counters, I thought it looked cleaner (and faster) this way.


Acked-by: Philippe Elie <phil.el@wanadoo.fr>

-- 
Phe

