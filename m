Return-Path: <linux-kernel-owner+w=401wt.eu-S967018AbXJSJYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967018AbXJSJYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXJSJY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:24:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38034 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755452AbXJSJYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:24:25 -0400
Date: Fri, 19 Oct 2007 02:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>, bryan.wu@analog.com,
       i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Blackfin I2C/TWI driver: update for 2.6.24 merge
 windows
Message-Id: <20071019022334.8e88e285.akpm@linux-foundation.org>
In-Reply-To: <20071019110750.33f66dd8@hyperion.delvare>
References: <1192456403.6215.5.camel@roc-laptop>
	<386072610710172311o7d2207f2he47e16c48016c2c2@mail.gmail.com>
	<20071019110750.33f66dd8@hyperion.delvare>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 11:07:50 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> BTW, as a rule of thumb, I am ignoring patches that are sent to the
> LKML in addition to the i2c list. If you think that your patch is so
> important that it has to be send to a list with over 4500 subscribers
> that sees 120.000 messages each year, then who am I to dare to comment
> on it?
> 
> If you want me to consider your patches as something that needs my
> attention, send them to the i2c list only, do not add LKML. This is
> general advice for everyone sending i2c patches, not just you, of
> course.

Disagree.  I don't think there's any benefit to anyone for developers to
hide their stuff on remote mailing lists.  Copying lkml increases the
changes that someone will spot a bug or some improvement and it generally
keeps people informed as to what's going on.

yeah, 120,000 messages/year.  But a lot of them are just noise.  Patches
are important.


And I really don't understand this huffy attitude and putting more
roadblocks in the way of our contributors.  People like Bryan are doing a
lot of work to improve Linux and most people are (or should be) grateful
for that and should be prepared to go the extra yard to help them.

