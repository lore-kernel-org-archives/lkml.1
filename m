Return-Path: <linux-kernel-owner+w=401wt.eu-S1758630AbXENTEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758630AbXENTEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbXENTEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:04:36 -0400
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:2924 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755038AbXENTEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:04:35 -0400
Date: Mon, 14 May 2007 21:05:22 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       "Alessandro Zummo" <alessandro.zummo@towertech.it>
Subject: Re: [PATCH] Add driver for Dallas DS1682 elapsed time recorder
Message-ID: <20070514210522.6b1ae8bc@hyperion.delvare>
In-Reply-To: <528646bc0705141029w397b11cejec17c770d64d7ce5@mail.gmail.com>
References: <20070513073906.24149.1292.stgit@trillian.secretlab.ca>
	<20070514105600.5095d38e@hyperion.delvare>
	<528646bc0705141029w397b11cejec17c770d64d7ce5@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007 11:29:04 -0600, Grant Likely wrote:
> BTW, I've just left the driver in drivers/i2c/chips.  It seems
> sufficiently different from an rtc (and the interface is totally
> difference) that putting it in drivers/rtc seems wrong.  If you
> disagree, I can change this.

That's fine with me, I have no strong opinion on this.

> Thanks for the comments,
> g.

You're welcome.

-- 
Jean Delvare
