Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYFASu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYFASu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 14:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYFASuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 14:50:13 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41261 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYFASuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 14:50:12 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: [Bug #10825] appletouch after wakeup
Date: Sun, 1 Jun 2008 20:29:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <dd18b0c30806011020i5f878f77qff504ffbe351b835@mail.gmail.com> <dd18b0c30806011125o1053171aged053f9a35f0de5a@mail.gmail.com>
In-Reply-To: <dd18b0c30806011125o1053171aged053f9a35f0de5a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806012029.09618.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 1. Juni 2008 20:25:03 schrieb Justin Mattock:
> On Sun, Jun 1, 2008 at 5:20 PM, Justin Mattock <justinmattock@gmail.com> wrote:
> > On Sun, Jun 1, 2008 at 10:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
> >> Am Sonntag, 1. Juni 2008 01:21:44 schrieb Justin Mattock:
> >>>  { USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
> >>
> >> This one.
> >>
> >>        Regards
> >>                Oliver
> >>
> >
> > Cool, I'll give it a go.
> > regards;
> >
> > --
> > Justin P. Mattock
> >
> 
> gripes; It seems appletouch is still tripping out upon wakeup.
> regards;
> 

Please also apply the patch from the following link:
https://bugzilla.novell.com/attachment.cgi?id=213908

	Regards
		Oliver

