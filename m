Return-Path: <linux-kernel-owner+w=401wt.eu-S1761027AbXK2HlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761027AbXK2HlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 02:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761348AbXK2Hjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 02:39:39 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:32799 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758949AbXK2Hjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 02:39:37 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: Add the infamous Huawei E220 to option.c
Date: Thu, 29 Nov 2007 08:38:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-usb@vger.kernel.org, preining@logic.at, kristoffer.ericson@gmail.com,
       drussell@redhat.com, johann.wilhelm@student.tugraz.at,
       linux-kernel@vger.kernel.org
References: <20071128161305.b01167b3.zaitcev@redhat.com>
In-Reply-To: <20071128161305.b01167b3.zaitcev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711290839.00625.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 29. November 2007 01:13:05 schrieb Pete Zaitcev:
> The problem stems from the fact that both option and usb-storage can bind
> to the modem when in storage mode: the former binds because of the storage
> class, the latter binds because of VID/PID match. The modprobe loads both,

Isn't it possible to fix this in option's module table?

	Regards
		Oliver

