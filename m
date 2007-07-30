Return-Path: <linux-kernel-owner+w=401wt.eu-S938274AbXG3DlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938274AbXG3DlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 23:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763376AbXG3DlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 23:41:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40199 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936981AbXG3DlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 23:41:11 -0400
Date: Mon, 30 Jul 2007 09:23:29 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 5/5] Use mutex instead of semaphore in the DVB frontend
 tuning interface
In-Reply-To: <20070729214341.GH3432@traven>
Message-ID: <alpine.LFD.0.999.0707300923070.10861@enigma.security.iitk.ac.in>
References: <20070729212909.GC3432@traven> <20070729214341.GH3432@traven>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Jul 2007, Matthias Kaehlcke wrote:

> The DVB frontend tuning interface uses a semaphore as mutex. Use the
> mutex API instead of the (binary) semaphore.
> 
> Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

Reviewed-by: Satyam Sharma <satyam@infradead.org>
