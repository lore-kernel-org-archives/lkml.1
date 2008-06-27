Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbYF0CrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbYF0CrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 22:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYF0CrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 22:47:05 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33812 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYF0CrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 22:47:03 -0400
Date: Thu, 26 Jun 2008 19:39:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net,
       LM Sensors <lm-sensors@lm-sensors.org>, Dmitry Torokhov <dtor@mail.ru>,
       Ben Dooks <ben@fluff.org>, mgross@linux.intel.com, hmh@hmh.eng.br,
       "Hans J. Koch" <hjk@linutronix.de>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: Accelerometer etc subsystem (Update on progress)
Message-Id: <20080626193912.5c66c32b.randy.dunlap@oracle.com>
In-Reply-To: <4863D97A.9090102@gmail.com>
References: <4832A211.4040206@gmail.com>
	<20080520132817.03fb74ea@hyperion.delvare>
	<4863D97A.9090102@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008 19:01:30 +0100 Jonathan Cameron wrote:

>     Documenation ;)

and Documentation ;)


Ugh.  Attachment.  Please send patches inline so that they can be reviewed
without having to do tons of copy-and-paste.  Possibly Documentation/email-clients.txt
can help you with thunderbird.

There are several typos in the Kconfig text parts...
and in source code comments.

>From Documentation/CodingStyle:

The preferred style for long (multi-line) comments is:

	/*
	 * This is the preferred style for multi-line
	 * comments in the Linux kernel source code.
	 * Please use it consistently.
	 *
	 * Description:  A column of asterisks on the left side,
	 * with beginning and ending almost-blank lines.
	 */

Please review/use Documentation/CodingStyle.

This Makefile (drivers/industrialio/misc/Makefile)
doesn't seem to do anything.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
