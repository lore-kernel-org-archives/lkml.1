Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYBIJjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYBIJjr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 04:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbYBIJji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 04:39:38 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:1652 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbYBIJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 04:39:37 -0500
Message-ID: <47AD74D4.5090304@free-electrons.com>
Date: Sat, 09 Feb 2008 10:39:32 +0100
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, hs4233@mail.mn-solutions.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: allow embedded targets to disable sysctl_check.c
References: <200802071438.58497.hs4233@mail.mn-solutions.de>	<20080207194735.35d87346.akpm@linux-foundation.org>	<m13as3d9ae.fsf@ebiederm.dsl.xmission.com> <20080208135816.f242a846.akpm@linux-foundation.org>
In-Reply-To: <20080208135816.f242a846.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2008 10:58 PM, Andrew Morton wrote:
> mm...  I'm inclined to merge the patch.  It's a decent saving, and it
> requires CONFIG_EMBEDDED which most people don't appear to set.
>   
That would be great! It does no harm to most people and doesn't make
things more complex to manage. And of course, it doesn't prevent from
improving sysctl support code in the long run.

Thanks!

:-)

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

