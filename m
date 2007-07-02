Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbXGBUTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbXGBUTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 16:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXGBUT1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 16:19:27 -0400
Received: from ns1.suse.de ([195.135.220.2]:44071 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbXGBUT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 16:19:27 -0400
Date: Mon, 2 Jul 2007 22:19:23 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: blink driver power saving
Message-ID: <20070702201923.GA30104@suse.de>
Mail-Followup-To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-kernel@vger.kernel.org
References: <51563.81.207.0.53.1183376603.squirrel@secure.samage.net> <200707021351.57965.ak@suse.de> <d120d5000707020531y43d41b6fl46e05c8343dbbeae@mail.gmail.com> <200707021439.27357.ak@suse.de> <d120d5000707020642j752ca814l501aaa543f9babcf@mail.gmail.com> <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000707020643y1b4f03ebid0ae37adb40d0a53@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov <dmitry.torokhov@gmail.com> [2007-07-02 15:43]:
> On 7/2/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
>>
>> I was thinking about something like the atached (untested and sorry
>> for using attachment). It shoudl blink just one led (numLock) on any
>> keyboard that has such LED (and allows to control it).
>>
>
> Argh, bad one. This one shoudl be better.

Ok, I didn't think of that possibility. That looks better than my
attempt to modify low-level console stuff ... :)


Thanks,
   Bernhard
