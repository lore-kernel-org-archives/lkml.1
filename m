Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbXHNNap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbXHNNap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 09:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbXHNNad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 09:30:33 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:37521 "EHLO
	smtp-out.kontent.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752560AbXHNNac convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 09:30:32 -0400
From: Oliver Neukum <oliver@neukum.org>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] spontaneous disconnect with "usb-storage: implement autosuspend"
Date: Tue, 14 Aug 2007 15:30:27 +0200
User-Agent: KMail/1.9.7
Cc: Paolo Ornati <ornati@fastwebnet.it>,
       Alan Stern <stern@rowland.harvard.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070814131557.5653d991@localhost>
In-Reply-To: <20070814131557.5653d991@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708141530.28182.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 14 August 2007 schrieb Paolo Ornati:
> Hi,
> 
> with "CONFIG_USB_SUSPEND=y", since commit:
> 
> 8dfe4b14869fd185ca25ee88b02ada58a3005eaf
>     usb-storage: implement autosuspend
>     
>     This patch (as930) implements autosuspend for usb-storage.  It is
>     adapted from a patch by Oliver Neukum.  Autosuspend is allowed except
>     during LUN scanning, resets, and command execution.
> 
> 
> my USB photo-camera gets automagically disconnected before I can do
> anything with it ;)
> 

hi,

I need vendor:product. Please provide "lsusb".
Generally a bug report for a specific usb device without vendor:product
is a bad idea.

	Regards
		Oliver

