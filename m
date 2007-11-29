Return-Path: <linux-kernel-owner+w=401wt.eu-S1761194AbXK2Kum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761194AbXK2Kum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXK2Kua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:50:30 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:33332 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbXK2Ku3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:50:29 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Rui Santos <rsantos@grupopie.com>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Thu, 29 Nov 2007 11:49:45 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pete Zaitcev <zaitcev@redhat.com>,
       Johann Wilhelm <johann.wilhelm@student.tugraz.at>,
       linux-usb@vger.kernel.org, preining@logic.at,
       kristoffer.ericson@gmail.com, drussell@redhat.com,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com> <20071129090926.GD24795@one-eyed-alien.net> <474E8DFE.4040300@grupopie.com>
In-Reply-To: <474E8DFE.4040300@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711291149.46326.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2007 11:01:34 schrieb Rui Santos:
> > Changing the unusual_devs.h flag to IGNORE_DEVICE should accomplish what
> > you want.
> >  
>
> If the IGNORE_DEVICE flag is set, access to the device's virtual-cd is
> no longer possible, and might not be the correct approach. Just as an
> example, one of my country's ISP has an ini file on it, with quite
> relevant information: Dial number, login, password and APN. Of course
> that, all of this information could be obtained with a simple phone call
> to that ISP.
>
> Just to remember that that specific flag was one SET and, was removed,
> in part, because of what I state. Of course we aim at perfection but, if
> the benefits are only for a few situations and, will cause all this
> problems for all other, perhaps the reinsert of that flag would be a
> positive action.

OK, can you provide "lsusb -v" for the device in the CD mode and in
the modem mode?

	Regards
		Oliver

