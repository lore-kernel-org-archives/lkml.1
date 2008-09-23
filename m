Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbYIWON5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbYIWON5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 10:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIWONq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 10:13:46 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:35802 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYIWONp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 10:13:45 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "=?iso-8859-1?q?S=F8ren?= Hauberg" <hauberg@gmail.com>
Subject: Re: [PATCH] usbtouchscreen, 2.6.25
Date: Tue, 23 Sep 2008 16:13:41 +0200
User-Agent: KMail/1.9.9
Cc: "Ondrej Zary" <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <ed7dcf450809230142l62bb00aapb92e6cb225f0cbba@mail.gmail.com> <200809231051.14016.linux@rainbow-software.org> <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com>
In-Reply-To: <ed7dcf450809230236v762e0aa3v8748c76a64121f0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200809231613.41905.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 23 September 2008 11:36:06 schrieb Søren Hauberg:
> 2008/9/23 Ondrej Zary <linux@rainbow-software.org>:
> > Calibration is a per-device thing. You can have more than one touchscreen (the
> > swap_xy feature is also wrong, but better than nothing).
> 
> Yes, this is true. I'm going to claim (and I have no factual evidence
> to back this claim, I'm just making it up) that almost all touchscreen
> users only have one touchscreen. So, I'd rather have something that
> works for most users, then the current situation. Is it optimal? No!
> Is it practical? I believe so. Using your words, it's "better than
> nothing".

But is it better than the X driver? How do other touchscreens do it?

	Regards
		Oliver
