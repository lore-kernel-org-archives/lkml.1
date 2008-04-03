Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbYDCIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbYDCIFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYDCIE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 04:04:56 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:44980 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223AbYDCIEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 04:04:54 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Stefan Schweizer <genstef@gentoo.org>
Subject: Re: suspend
Date: Thu, 3 Apr 2008 10:02:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <200804030932.27993.oliver@neukum.org> <ft21pb$oc3$1@ger.gmane.org>
In-Reply-To: <ft21pb$oc3$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031002.56918.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 3. April 2008 09:42:00 schrieb Stefan Schweizer:
> Oliver Neukum wrote:
> > Please load the appletouch module with the parameter "debug=1" and
> > post dmesg of a suspend/resume and the chvt thing.
> 
> I found out the appletouch issue was already discused here:
> http://lkml.org/lkml/2007/3/28/172
> 
> Unfortunately there seems to be no workaround and X-input still has more
> issues than it solves..
> 
> Attached is the dmesg excerpt

According to dmesg the kernel part works correctly. This is an X problem
as diagnosed in the thread you sent a link to.

	Sorry
		Oliver

