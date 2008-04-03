Return-Path: <linux-kernel-owner+w=401wt.eu-S1760943AbYDCVYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760943AbYDCVYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 17:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760651AbYDCVY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 17:24:29 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:60487 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757126AbYDCVY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 17:24:28 -0400
Date: Thu, 3 Apr 2008 17:24:27 -0400
To: Bob Copeland <me@bobcopeland.com>
Cc: Xavier Bestel <xavier.bestel@free.fr>,
       Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ASUS ScreenDuo
Message-ID: <20080403212427.GE24239@csclub.uwaterloo.ca>
References: <Pine.LNX.4.44L0.0804031506300.7376-100000@iolanthe.rowland.org> <1207251545.24007.3.camel@bip.parateam.prv> <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0804031358q46379223ud4839c0de01290cf@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2008 at 04:58:03PM -0400, Bob Copeland wrote:
> If you have a friend with this device and windows, you might be able to
> capture the initialization sequence using usbsnoopy or something similar.
> Some devices just need a little proprietary poke before they become a normal
> USB device.

Well apparently vista expects the device to support running programs
written in .NET Micro Framework.  Maybe that is some JVM like thingy.  I
am not sure what Microsoft means by "Managed Code".  Since it seems to
be architecture independant I imagine it is similar to java byte code or
something similar.

Perhaps vista writes the firmware/OS to the mass storage device and they
talks to it after that.  Is there such a thing as a write only usb mass
storage device?

-- 
Len Sorensen
