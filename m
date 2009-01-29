Return-Path: <linux-kernel-owner+w=401wt.eu-S1759141AbZA2UMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141AbZA2UMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 15:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbZA2UMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 15:12:05 -0500
Received: from mx0.towertech.it ([213.215.222.73]:34207 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752731AbZA2UMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 15:12:02 -0500
Date: Thu, 29 Jan 2009 21:11:59 +0100
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: rtc-linux@googlegroups.com
Cc: eswierk@aristanetworks.com, tglx@linutronix.de, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [PATCH] x86: i2c rtc instead of cmos rtc
Message-ID: <20090129211159.78714c5c@i1501.lan.towertech.it>
In-Reply-To: <9ae48b020901291205ie0db5abj1a8c06528b9b46e8@mail.gmail.com>
References: <1233018263.14510.112.camel@localhost.localdomain>
	<20090127122156.784924f4@i1501.lan.towertech.it>
	<9ae48b020901291121n319be519o473db5fdc031ea8f@mail.gmail.com>
	<20090129204104.60bf46a2@i1501.lan.towertech.it>
	<9ae48b020901291205ie0db5abj1a8c06528b9b46e8@mail.gmail.com>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 12:05:26 -0800
Ed Swierk <eswierk@aristanetworks.com> wrote:

> Would you prefer a single option to select the rtc (something like
> rtc.device={cmos|i2c,ds1339,1,0x68})? Or do you object to any option
> at all?

 I object to options of this kind. It took us a lot of efforts to move
 to the new i2c model and to the concept that devices have to be declared
 in the board support code. This kind of hack is in the opposite direction.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

