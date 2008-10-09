Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYJIId4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYJIId4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYJIIdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:33:46 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57013 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJIIdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:33:45 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Folkert van Heusden <folkert@vanheusden.com>
Subject: Re: [2.6.27-rc7] oops in usbcore
Date: Thu, 9 Oct 2008 10:33:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, USB list <linux-usb@vger.kernel.org>
References: <20081009082946.GG23933@vanheusden.com>
In-Reply-To: <20081009082946.GG23933@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810091033.43665.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 9. Oktober 2008 10:29:50 schrieb Folkert van Heusden:

> lpc-ntpd is a atomic clock receiver driver doing read()-calls on an fd
> from a serial device (connected via usb), nothing fancy
> (http://vanheusden.com/lpc-ntpd/ ).

Which devices? Please post lsusb -v

	Regards
		Oliver
