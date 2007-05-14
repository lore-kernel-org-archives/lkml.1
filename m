Return-Path: <linux-kernel-owner+w=401wt.eu-S1760177AbXENGVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177AbXENGVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757950AbXENGVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:21:25 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:2858 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752342AbXENGVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:21:25 -0400
Date: Mon, 14 May 2007 08:22:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, i2c@lm-sensors.org,
       Antonino Ingargiola <tritemio@gmail.com>
Subject: Re: [1/2] 2.6.22-rc1: known regressions
Message-ID: <20070514082207.5df59f6e@hyperion.delvare>
In-Reply-To: <46475595.4050105@googlemail.com>
References: <46475595.4050105@googlemail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Sun, 13 May 2007 20:14:45 +0200, Michal Piotrowski wrote:
> 
> I2C
> 
> Subject    : "Sensors Applet" give an error message "No chip detected"
> References : http://lkml.org/lkml/2007/5/13/109
> Submitter  : Antonino Ingargiola <tritemio@gmail.com>
> Status     : Unknown

There is currently zero proof that this has anything to do with I2C.

-- 
Jean Delvare
