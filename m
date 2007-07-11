Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbXGKP3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbXGKP3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759094AbXGKP3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:29:25 -0400
Received: from h155.mvista.com ([63.81.120.155]:25955 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757422AbXGKP3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:29:24 -0400
Message-ID: <4694F7CD.8040606@ru.mvista.com>
Date: Wed, 11 Jul 2007 19:31:25 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Songmao Tian <tiansm@lemote.com>, linuxbios@linuxbios.org,
       marc.jones@amd.com, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
References: <4694A495.1050006@lemote.com> <4694F5B8.50009@ru.mvista.com>
In-Reply-To: <4694F5B8.50009@ru.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> it's a problem that my northbridge didn't implement that! Fortunately 
>> we use a fpga as a northbridge.

>    Wait, CS5536 is a nortbridge itself!

    Apparently, it's only a south bridge. I must've mixed it with Geode itself.

WBR, Sergei
