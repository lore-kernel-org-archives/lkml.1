Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYKZRPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYKZRPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbYKZRPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:15:30 -0500
Received: from kroah.org ([198.145.64.141]:55146 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752935AbYKZRP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:15:29 -0500
Date: Wed, 26 Nov 2008 09:07:15 -0800
From: Greg KH <greg@kroah.com>
To: Joe Korty <joe.korty@ccur.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linux API <linux-api@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Display active jiffie timers in /proc/timer_list, v2
Message-ID: <20081126170715.GA28422@kroah.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com> <20081126164845.GA17394@tsunami.ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126164845.GA17394@tsunami.ccur.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:48:45AM -0500, Joe Korty wrote:
> Add an 'active jiffie timers' subdisplay to /proc/timer_list, v2.

Can you add the documentation for this new field to Documentation/ABI/
as you are changing/adding a public API.

thanks,

greg k-h
