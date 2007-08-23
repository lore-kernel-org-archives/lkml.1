Return-Path: <linux-kernel-owner+w=401wt.eu-S1763032AbXHWNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763032AbXHWNdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760941AbXHWNdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:33:24 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2392 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbXHWNdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:33:23 -0400
Date: Thu, 23 Aug 2007 15:33:43 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Avi Kivity <avi@qumranet.com>
cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] Move PREEMPT_NOTIFIERS into an always-included Kconfig
In-Reply-To: <1187861641842-git-send-email-avi@qumranet.com>
Message-ID: <Pine.LNX.4.64.0708231531590.1817@scrub.home>
References: <1187861641842-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 23 Aug 2007, Avi Kivity wrote:

> Pointing out that this
> is a Kconfig bug does not seem to silence the error,

*sigh*
This is not a Kconfig bug!

bye, Roman
