Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbYHUGIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbYHUGIB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbYHUGHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:07:52 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:56846 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYHUGHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:07:51 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: amruth_pv@yahoo.com
Subject: Re: USB Serial device disconnect causes IRQ disable
Date: Thu, 21 Aug 2008 08:09:01 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <649688.7131.qm@web45210.mail.sp1.yahoo.com>
In-Reply-To: <649688.7131.qm@web45210.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210809.01517.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 21 August 2008 08:03:57 schrieb amruth:
> > What happens when you never plug in the device?
> Everything works fine without plugging the device. I have memory stick 
> which never creates any problem.

OK, do you have any other USB device on the same bus as your serial
converter?

	Regards
		Oliver

