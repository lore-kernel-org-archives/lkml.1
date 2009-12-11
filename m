Return-Path: <linux-kernel-owner+w=401wt.eu-S1762305AbZLKMEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762305AbZLKMEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756709AbZLKMEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:04:47 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:42946 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZLKMEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:04:46 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Ivan Zahariev <famzah@icdsoft.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: EUID != root + EGID = root, and CAP_SETGID
References: <4B222C3D.2070807@icdsoft.com>
X-Yow: I'm gliding over a NUCLEAR WASTE DUMP near ATLANTA, Georgia!!
Date: Fri, 11 Dec 2009 13:04:49 +0100
In-Reply-To: <4B222C3D.2070807@icdsoft.com> (Ivan Zahariev's message of "Fri,
	11 Dec 2009 13:25:49 +0200")
Message-ID: <m2r5r1lnry.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Zahariev <famzah@icdsoft.com> writes:

> As a result, such a process cannot change its EGID to an arbitrary one,
> even though the current EGID is the super-user "root" one.

There is no such thing as a "super-user group".  No group has any
special privleges.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
