Return-Path: <linux-kernel-owner+w=401wt.eu-S1756181AbXLBSHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbXLBSHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbXLBSH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:07:27 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:56771 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbXLBSHZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:07:25 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>, linux-usb@vger.kernel.org
Subject: Re: 2.6.24:  false double-clicks from USB mouse
Date: Sun, 2 Dec 2007 19:06:51 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <4752DB8C.50608@rtr.ca>
In-Reply-To: <4752DB8C.50608@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712021906.52564.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 2. Dezember 2007 17:21:32 schrieb Mark Lord:
> I've grabbed mousedev.c from 2.6.23 and inserted that in place
> of the updated 2.6.24 source, but no change.  So it's not that file.

Are you really using mousedev and not true hid?
Do you see any other malfunction?

	Regards
		Oliver

