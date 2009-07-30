Return-Path: <linux-kernel-owner+w=401wt.eu-S1751938AbZG3Qwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938AbZG3Qwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbZG3Qwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 12:52:32 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37527 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbZG3Qwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 12:52:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=a4HHZRHYuVLIhwNm2zpifE1yL4+JRMuxUrF9BtvC6oHWDaKEM0CEZdyhvHMfIlS2SK
         sOfYowC9wW7LvmBNcwed27JxzKGxyvioPXXpNbWQUJofF6efxB+8eKwILLy6RMJqtMbi
         OtIQ08BStNNo8EsNErDMZ5K4Oqm/B7GPCRC6E=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [wireless] rt2870sta BUGs on shutdown, 2.6.30.2->git.today+git.wireless.today
Date: Thu, 30 Jul 2009 18:52:27 +0200
User-Agent: KMail/1.9.10
Cc: Luis Correia <luis.f.correia@gmail.com>, Mike Galbraith <efault@gmx.de>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
References: <1248945770.7910.24.camel@marge.simson.net> <efe7343f0907300306o44d0e718p2880b7406a38fc6a@mail.gmail.com> <200907301517.57811.bzolnier@gmail.com>
In-Reply-To: <200907301517.57811.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907301852.28172.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I planned, and actually did write, a lengthy reply for this thread, when I completed the reply
I reconsidred and opted for this shorter reply. Every 2 or 3 months this discussion is started
again and I am f***ing tired of it, so excuse me but I am not going to throw myself into
this completely pointless discussion

What you are suggesting in your mail is something the rt2x00 project did for 5 years, we stopped
with that 4 months ago because it wasn't working out. Apparently you have more experience in this
matter so I hope you will find a way to make that solution work out.

If you want to maintain the legacy drivers then do it, start a new project and start maintaining
the code. I can forward you all the users with complains about the "good enough" drivers. It is
good to know that you apparently have the resources to maintain the old drivers. 
Most people who are helping with the rt2800pci/usb drivers lack the required time to boost the driver
into such a state it can be widely adopted. But every time it amazes me that the people who want
to develop and have the time to do it, all want to jump on the old Ralink code... Apparently there
is some appeal to maintaining crap rather then helping to ship out proper drivers to the users.

But I'll shut up now, as I said this discussion is held every few months, so perhaps that when
the discussion is started again in a couple of months I am more interested in a lengthy reply.

Ivo
