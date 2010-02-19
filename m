Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab0BSXCZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 18:02:25 -0500
Received: from mail.crca.org.au ([67.207.131.56]:39471 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab0BSXCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 18:02:24 -0500
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4B7F1919.2010605@tuxonice.net>
Date: Sat, 20 Feb 2010 10:04:57 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: Re: [PATCH 1/1] PM / Hibernate: remove swsusp.c
References: <1266620017-11061-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1266620017-11061-1-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 0.95.7
OpenPGP: id=8B613241
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Jiri Slaby wrote:
> Its contents and entry in Makefile were already removed in
> 8e60c6a1348e17e68ad73589a52a03876e7059be
> (Shift remaining code from swsusp.c to hibernate.c)
> but somehow it remained in-place.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <nigel@tuxonice.net>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Yeah. The version that was actually committed was different to the patch
I sent.

Acked-by: Nigel Cunningham <nigel@tuxonice.net>
