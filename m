Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab0BUWMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 17:12:54 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:58609 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab0BUWMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 17:12:52 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Sun, 21 Feb 2010 23:12:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc8-0.1-default; KDE/4.3.1; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, dvomlehn@cisco.com,
       gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002211627430.32083-100000@netrider.rowland.org> <201002212342.12301.anssi.hannula@iki.fi>
In-Reply-To: <201002212342.12301.anssi.hannula@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002212312.36320.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 21. Februar 2010 22:42:12 schrieb Anssi Hannula:
> And of course this doesn't explain why it hangs (and the WARNING) if I remove 
> the sleep calls I added in gobi_loader.

Please tell us where you put a delay.

	Regards
		Oliver
