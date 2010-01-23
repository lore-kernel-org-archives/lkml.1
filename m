Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375Ab0AWKnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab0AWKnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 05:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752538Ab0AWKnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 05:43:16 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:45081 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0AWKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 05:43:15 -0500
Message-ID: <4B5AD2C3.4020409@pardus.org.tr>
Date: Sat, 23 Jan 2010 12:43:15 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Nathan Williams <ngwilliams@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com>
In-Reply-To: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Williams wrote:
> I'm having trouble with my PC crashing just as it's attempting to power off.
> I managed to git bisect to this commit:
> 

http://bugzilla.kernel.org/show_bug.cgi?id=15037
http://patchwork.kernel.org/patch/71537/
