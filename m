Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZA2VNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZA2VNA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 16:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbZA2VMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 16:12:51 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:20622 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZA2VMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 16:12:50 -0500
MIME-Version: 1.0
In-Reply-To: <20090129211159.78714c5c@i1501.lan.towertech.it>
References: <1233018263.14510.112.camel@localhost.localdomain>
	 <20090127122156.784924f4@i1501.lan.towertech.it>
	 <9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
	 <20090129204104.60bf46a2@i1501.lan.towertech.it>
	 <9ae48b020901291205ie0db5abj1a8c06528b9b46e8@mail.gmail.com>
	 <20090129211159.78714c5c@i1501.lan.towertech.it>
Date: Thu, 29 Jan 2009 13:12:49 -0800
Message-ID: <9ae48b020901291312v459b4cddg4a991de2d4ef54bf@mail.gmail.com>
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

On Thu, Jan 29, 2009 at 12:11 PM, Alessandro Zummo
<alessandro.zummo@towertech.it> wrote:
>  I object to options of this kind. It took us a lot of efforts to move
>  to the new i2c model and to the concept that devices have to be declared
>  in the board support code. This kind of hack is in the opposite direction.

I see. I encountered board support code when I worked with PowerPC
boards on Linux years ago but I haven't seen this in the x86 arch
code. Can you point me to an example?

--Ed
