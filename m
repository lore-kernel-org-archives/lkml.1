Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYANTvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYANTvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753624AbYANTuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:50:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40548 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYANTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:50:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <478BBCE6.5020005@s5r6.in-berlin.de>
Date: Mon, 14 Jan 2008 20:49:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Al Boldi <a1426z@gawab.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/5] USB Kconfig: Reorganize USB Kconfig Menu
References: <200801051546.SAA08937@raad.intranet> <20080112195333.GA4924@kroah.com> <4789FAF8.8080107@s5r6.in-berlin.de> <200801141321.51185.a1426z@gawab.com> <20080114181239.GB14814@kroah.com>
In-Reply-To: <20080114181239.GB14814@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 14, 2008 at 01:21:51PM +0300, Al Boldi wrote:
>> Stefan Richter wrote:
>>> would you please explain like I asked you:
>>>   - what is wrong with the current solution which tells the user to
>>>     first enable SCSI to get the USB_STORAGE option,
>>>   - whether there are frequent end-user requests which demonstrate
>>>     that many people currently don't realize how to enable USB_STORAGE.
...
>> I thought we discussed this before.  We do it here, for the same reasons 
>> libata does it.  In any case, the patch is optional.

Al,
I admit I haven't read everything of the discussion.  So, sorry if I got
on your nerves.  (However, http://lkml.org/lkml/2008/1/5/151 and
http://lkml.org/lkml/2008/1/5/209 didn't yield responses which addressed
the mentioned points.  Also, "libata's reasons for doing so apply to
usb-storage as well" is not a fact-based answer to these points either.
Anyway, sorry if I missed an according response elsewhere.)

> Yes, I do not want to do this, as we went round and round on it in the
> past many times over the years.  It should be left as-is.

I'm relieved.  :-)
-- 
Stefan Richter
-=====-==--- ---= -===-
http://arcgraph.de/sr/
