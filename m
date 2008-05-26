Return-Path: <linux-kernel-owner+w=401wt.eu-S1756624AbYEZRKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624AbYEZRKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbYEZRKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:10:00 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:54911 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbYEZRJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:09:59 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Date: Mon, 26 May 2008 19:09:57 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu>
In-Reply-To: <20080526170147.GB9893@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805261909.59032.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 26 Mai 2008 19:01:48 schrieb Theodore Tso:
> If the USB stack folks would like to work on how to recognize that
> it's the same USB stick that had been previously pulled, so that it
> gets the same block device, and we can decide for how long we should
> keep dirty buffers around associated with a pulled USB stick, we can
> certainly have that conversation.  :-)

Even if we could tell whether the device has remained the same, how
would we know the medium wasn't exchanged?

	Regards
		Oliver

