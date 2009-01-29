Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZA2UFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZA2UFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZA2UF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:05:28 -0500
Received: from yw-out-2324.google.com ([74.125.46.28]:2457 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZA2UF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:05:27 -0500
MIME-Version: 1.0
In-Reply-To: <20090129204104.60bf46a2@i1501.lan.towertech.it>
References: <1233018263.14510.112.camel@localhost.localdomain>
	 <20090127122156.784924f4@i1501.lan.towertech.it>
	 <9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
	 <20090129204104.60bf46a2@i1501.lan.towertech.it>
Date: Thu, 29 Jan 2009 12:05:26 -0800
Message-ID: <9ae48b020901291205ie0db5abj1a8c06528b9b46e8@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH] x86: i2c rtc instead of cmos rtc
From: Ed Swierk <eswierk@aristanetworks.com>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 29, 2009 at 11:41 AM, Alessandro Zummo
<alessandro.zummo@towertech.it> wrote:
>  While I can't judge on what's convenient to you, I do not feel
>  fine in having a kernel option to disable the rtc and another to load
>  a specific i2c one.

Would you prefer a single option to select the rtc (something like
rtc.device={cmos|i2c,ds1339,1,0x68})? Or do you object to any option
at all?

--Ed
