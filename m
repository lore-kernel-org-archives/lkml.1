Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYHLA2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYHLA2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 20:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbYHLA2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 20:28:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033AbYHLA2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 20:28:11 -0400
Date: Mon, 11 Aug 2008 17:27:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: tobias@himmer-online.de, i2c@lm-sensors.org, linux-kernel@vger.kernel.org,
       bigeasy@linutronix.de, hjk@linutronix.de, fishor@mail.ru
Subject: Re: [PATCH] hwmon: Included max1618 support in max1619 driver
Message-Id: <20080811172721.5ef6c1f6.akpm@linux-foundation.org>
In-Reply-To: <20080811122102.034f6f2f@hyperion.delvare>
References: <200808111141.12891.tobias@himmer-online.de>
	<20080811122102.034f6f2f@hyperion.delvare>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 12:21:02 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> On Mon, 11 Aug 2008 11:41:12 +0200, Tobias Himmer wrote:
> > Hi,
> > 
> > I modified the existing max1619 driver in order to support the MAX1618 chip,
> > a stripped down version of the MAX1619.
> 
> Wrong mailing list. Please send to the lm-sensors list.
> 

Please also prepare and test the patch against current Linus mainline. 
Or even linux-next, although that isn't necessary in this particular case.

Your patch appeared to be against 2.6.26, and that was a long time ago
in kernel terms.  It is not applicable to current development kernels.

