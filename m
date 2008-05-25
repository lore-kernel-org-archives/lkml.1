Return-Path: <linux-kernel-owner+w=401wt.eu-S1760235AbYEYLn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235AbYEYLn0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYEYLnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:43:16 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4221 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755390AbYEYLnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:43:16 -0400
Date: Sun, 25 May 2008 13:43:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on PRIMEQUEST
Message-ID: <20080525114308.GA5237@ucw.cz>
References: <4816F9B9.3090609@jp.fujitsu.com> <4836660B.3080406@jp.fujitsu.com> <483667A4.9000606@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483667A4.9000606@jp.fujitsu.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-05-23 15:43:48, Taku Izumi wrote:
> This patch adds DMI info to enable OSI(Linux) on 
> PRIMEQUEST.
> (PRIMEQUEST is ia64 machine.)

Why is it needed? Why needs your bios know whether it is Linux or BSD
or whatver running?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
