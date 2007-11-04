Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbXKDXMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbXKDXMb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbXKDXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:12:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXKDXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:12:23 -0500
Message-ID: <472E51C1.5080800@zytor.com>
Date: Sun, 04 Nov 2007 15:12:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] fix i486 boot failure due to stale %ds
References: <200711042158.lA4Lwv9S014628@harpo.it.uu.se> <472E50C5.5020201@goop.org>
In-Reply-To: <472E50C5.5020201@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Yes, that's what the spec says.  I queried this a few months ago, but
> hpa used his convincing voice and said that in practice it isn't
> necessary; there are no known cpus which need this, and any that do
> would cause other things to break.  But I guess now we have the
> counter-example...
> 

Yup.  I owe you a beverage :)

	-hpa
