Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXCUWUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXCUWUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933334AbXCUWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:20:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50829 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933161AbXCUWUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:20:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: remove-unused-header-file-include-linux-elfnoteh.patch
Date: Wed, 21 Mar 2007 23:20:35 +0100
User-Agent: KMail/1.9.6
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4601A56A.40609@goop.org>
In-Reply-To: <4601A56A.40609@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703212320.35920.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/rGk2HxZ/eTclNxomO/8SguD7GOQQE/3o6CXw
 T7ik4R/zo3xpwJ9Uw6sJVhAIYZS7LdKawk+Q5DnTadmYf6ERV8
 xSR0Y+TXdI1lW0mAAPi0Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2007 22:36:42 Jeremy Fitzhardinge wrote:
> Please don't.  We need it.
>
> BTW, I didn't see this one go by, and I couldn't see it searching
> around.  Did it get posted to lkml?

I think it was only on the janitor list. It was considered
obviously correct since it does not get installed by
headers_installed and did not seem to be used anywhere in
the kernel.

Could you explain how this file is used in the kernel? Robert
probably wants to update his script to handle this correctly.

	Arnd <><
