Return-Path: <linux-kernel-owner+w=401wt.eu-S1752246AbXCYF3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246AbXCYF3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXCYF3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:29:35 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:21853 "EHLO
	asav17.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXCYF3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:29:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAD+lBUZKhRO4dGdsb2JhbACPYQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Parag Warudkar <parag.warudkar@gmail.com>
Subject: Re: keyboard.c: Stop flooding dmesg with useless warnings
Date: Sun, 25 Mar 2007 01:29:32 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Jiri Kosina <jkosina@suse.cz>
References: <Pine.LNX.4.64.0703242315160.492@paragw-desktop> <200703250115.02029.dtor@insightbb.com> <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
In-Reply-To: <82e4877d0703242227q7961833aie851e14764002264@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703250129.32877.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 March 2007 01:27, Parag Warudkar wrote:
> >
> > Actually the keyboard driver should not emit input events for that key code.
> > Is this a USB keyboard?
> >
> > --
> > Dmitry
> >
> 
> Yes this is a USB keyboard.
> 
> Any hint as to where I should start looking to make the driver not
> emit input event for keycode==0?
>

Was it always doing that? I'll add Jiri Kosina to the CC list as he's
involved with HID now.

-- 
Dmitry
