Return-Path: <linux-kernel-owner+w=401wt.eu-S1755648AbXK3JQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648AbXK3JQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbXK3JPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:15:55 -0500
Received: from mail.univits.se ([212.247.11.167]:43949 "EHLO mail.univits.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756427AbXK3JPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:15:54 -0500
Message-ID: <474FD4C1.4030906@univits.com>
Date: Fri, 30 Nov 2007 10:15:45 +0100
From: =?UTF-8?B?TWlrYWVsIFN0w6VsZGFs?= <mikael.staldal@univits.com>
Organization: Univits
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
   limit
References: <4742B3A3.2050103@univits.com> <20071120155303.76f234ec@astralstorm.puszkin.org> <474A975A.8020302@univits.com> <474C9D6A.4000505@cfl.rr.com>
In-Reply-To: <474C9D6A.4000505@cfl.rr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Phillip Susi skrev:
> Mikael Ståldal wrote:
>> And how do you protect ports >1024 from any user binding to them?
>
> You prevent users from binding to those ports by only giving 
> applications that need to the capability, and only letting the users 
> that need to have execute permission to those programs.

I think you misunderstood my question.

How do you protect ports greater than 1024 from any user binding to them? E.g. port 1080.

/Mikael

