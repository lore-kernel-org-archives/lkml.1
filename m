Return-Path: <linux-kernel-owner+w=401wt.eu-S1751826AbZKISeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbZKISeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 13:34:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbZKISet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 13:34:49 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:45262 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbZKISet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 13:34:49 -0500
Date: Mon, 09 Nov 2009 17:54:38 +0000
From: Darren Salt <linux@youmustbejoking.demon.co.uk>
To: bzolnier@gmail.com
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rt28x0: remove no longer needed common/cmm_data_2860.c
In-Reply-To: <200911091720.39821.bzolnier@gmail.com>
References: <200911091720.39821.bzolnier@gmail.com>
Message-ID: <50BD09C528%linux@youmustbejoking.demon.co.uk>
Mail-Followup-To: bzolnier@gmail.com, gregkh@suse.de,
 devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
 linux@youmustbejoking.demon.co.uk
User-Agent: Messenger-Pro/2.60.0.3101 (Qt/4.5.3) (Linux-x86_64)
X-NuLabour-Date: Mon, 9110 Dec 1984 17:54:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 192.168.0.5
X-SA-Exim-Mail-From: linux@youmustbejoking.demon.co.uk
X-SA-Exim-Scanned: No (on pentagram.youmustbejoking.demon.co.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your removal of cmm_data_2860.c also removes a bug fix (commit
0af49167b1e5ba154e90d2c454bf4624ee47df80; for background, see
http://bugzilla.kernel.org/show_bug.cgi?id=13390).

Is this fix present (or, better, not needed) in the code which obsoletes this
file? (I can test if needed; just point me in the right direction wrt patches
or repositories.)

-- 
| Darren Salt            | linux at youmustbejoking | nr. Ashington, | Doon
| using Debian GNU/Linux | or ds    ,demon,co,uk    | Northumberland | Army
|   Kill all extremists!

Congratulations! The pressure will stop soon.
