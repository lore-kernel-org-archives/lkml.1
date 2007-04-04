Return-Path: <linux-kernel-owner+w=401wt.eu-S2992643AbXDDFoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992643AbXDDFoY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 01:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992640AbXDDFoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 01:44:24 -0400
Received: from smtp.osdl.org ([65.172.181.24]:58547 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992584AbXDDFoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 01:44:23 -0400
Date: Tue, 3 Apr 2007 22:44:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.osdl.org,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4 -- laptop lid button only triggers suspend on HP
 dv1240us every other time.
Message-Id: <20070403224420.7dcfe334.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0704032233sa893351le119152668557e72@mail.gmail.com>
References: <a44ae5cd0704032233sa893351le119152668557e72@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 00:33:36 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> This is an old bug.  It has been happening forever, but I'd love to
> know how I can help get this tracked down and fixed.

Yes, I've been hitting something like that in the past 3-4 weeks.  We
started to diagnose it but I got distracted.

For a start, please review
http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg05094.html, then
see if you are able to take it further than I was.

