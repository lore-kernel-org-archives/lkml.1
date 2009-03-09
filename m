Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZCIPu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZCIPu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:50:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCIPuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:50:19 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43129 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbZCIPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:50:18 -0400
Date: Tue, 10 Mar 2009 00:46:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       Kyle McMartin <kyle@mcmartin.ca>, rtc-linux@googlegroups.com,
       linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dann Frazier <dannf@dannf.org>
Subject: Re: [PATCH 0/7] Generic RTC class driver
Message-ID: <20090309154617.GA31103@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Alessandro Zummo <alessandro.zummo@towertech.it>,
	Kyle McMartin <kyle@mcmartin.ca>, rtc-linux@googlegroups.com,
	linux-parisc@vger.kernel.org, linuxppc-dev@ozlabs.org,
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dann Frazier <dannf@dannf.org>
References: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236605183-22718-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 02:26:16PM +0100, Geert Uytterhoeven wrote:
> Paul: Feel free to add your SuperH support.
> 
> I suppose the easiest way for this to go in is through Kyle's PA-RISC tree, as
> he already has the preceding patches? Can I have your acks, please?
> 
I'll add the SH support once the patch set is merged, it's not a very
pressing matter, so no need to make the patch juggling any more
complicated :-)
