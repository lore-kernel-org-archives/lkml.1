Return-Path: <linux-kernel-owner+w=401wt.eu-S1757977AbYGDGwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977AbYGDGwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 02:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYGDGvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 02:51:52 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:59899 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbYGDGvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 02:51:51 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: alphabetic ordering of MAINTAINERS
Date: Fri, 4 Jul 2008 08:52:27 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
References: <20080704063455.GA13999@digi.com>
In-Reply-To: <20080704063455.GA13999@digi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807040852.27809.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 04 Juli 2008 08:34:55 schrieb Uwe Kleine-König:
> Hello,
> 
> I wanted to add an entry to MAINTAINERS and while doing it I saw that in
> the corresponding region the alphabetic ordering is broken.  Then I
> inteded to fix that up for a trivial patch.  Next was to check the rest
> of the file and there are so much misorderings that it's not sensible to
> choose the trivial path anymore as there are currently 114 entries out
> of order[1].

What good does alphabetic ordering? You'll grep it anyway.

	Regards
		Oliver

