Return-Path: <linux-kernel-owner+w=401wt.eu-S932295AbYBZV5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbYBZV5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766010AbYBZV5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:57:13 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:49346 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765997AbYBZV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:57:11 -0500
Date: Tue, 26 Feb 2008 13:54:44 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: ricknu-0@student.ltu.se
Cc: khc@pm.waw.pl, bhalevy.lists@gmail.com, jengelh@computergmbh.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] CodeStyle: Use spaces when aligning/decorating
Message-Id: <20080226135444.f83a0536.randy.dunlap@oracle.com>
In-Reply-To: <1204062430.47c488def40a4@portal.student.luth.se>
References: <1204062430.47c488def40a4@portal.student.luth.se>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008 22:47:10 +0100 ricknu-0@student.ltu.se wrote:

> Relaxing the 'tab = 8 character', which leads to 'don't tab the alignment'.
> By only using tabs for indentation, we solidify it as a 'logical indentation'.
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> To'ed the people who showed interest in the (apparently not so new)
> question/suggestion of not using tabs when aligning.
> If this looks ok, then checkpatch.pl is next...
> 
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 6caa146..1b3f448 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -15,10 +15,8 @@ Anyway, here goes:
>  
>  	 	Chapter 1: Indentation
>  
> -Tabs are 8 characters, and thus indentations are also 8 characters.
> -There are heretic movements that try to make indentations 4 (or even 2!)
> -characters deep, and that is akin to trying to define the value of PI to
> -be 3.
> +This project is recommended to be viewed with a tab-width of 8 characters
> +(and other code).

FWIW I prefer the {deleted} language.  // PI = 3;

>  Rationale: The whole idea behind indentation is to clearly define where
>  a block of control starts and ends.  Especially when you've been looking


---
~Randy
