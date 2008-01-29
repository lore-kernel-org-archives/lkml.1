Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYA2Rjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYA2Rjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757527AbYA2Rj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:39:27 -0500
Received: from smtp-out001.kontent.com ([81.88.40.215]:45410 "EHLO
	smtp-out001.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYA2RjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:39:24 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 18:42:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Jens Axboe <jens.axboe@oracle.com>, Greg KH <greg@kroah.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
References: <20080128204935.GI15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <479F4B4B.2020000@panasas.com>
In-Reply-To: <479F4B4B.2020000@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801291842.57937.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Januar 2008 16:50:35 schrieb Boaz Harrosh:
> On Tue, Jan 29 2008 at 16:31 +0200, Oliver Neukum <oliver@neukum.org> wrote:
 
> I can not see what it is. Yes CONFIG_USB_STORAGE_DEBUG will help.
> I have a device here that uses the same trasport/protocol I'll
> try to reproduce the failure here.

This is the most common combination of transport and protocol. If it were
broken in a larger number of cases, we'd hear more reports. You'll probably
need the debug output to figure out what's wrong.

	Regards
		Oliver
