Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab0BRSEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:04:08 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42057 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752620Ab0BRSED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:04:03 -0500
Date: Thu, 18 Feb 2010 18:03:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>, "Theodore Ts'o" <tytso@mit.edu>,
       Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] Remove drivers/char/ChangeLog
Message-ID: <20100218180301.2e60c6a3@lxorguk.ukuu.org.uk>
In-Reply-To: <20100218095200.63509b8c@bike.lwn.net>
References: <20100218095200.63509b8c@bike.lwn.net>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Feb 2010 09:52:00 -0700
Jonathan Corbet <corbet@lwn.net> wrote:

> The ChangeLog file under drivers/char is 30K of stuff dedicated to the
> mid-90's TTY exploits of Ted Ts'o; it has been updated once since 1998
> - and that was in 2001.  It's interesting history, but we don't
> normally carry that kind of history inline with the code.  Let's remove
> it.

Acked-by: Alan Cox <alan@linux.intel.com>

It's no longer useful - or indeed even accurate


Alan
