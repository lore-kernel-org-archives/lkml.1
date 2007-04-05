Return-Path: <linux-kernel-owner+w=401wt.eu-S1767389AbXDEWjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767389AbXDEWjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 18:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767387AbXDEWjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 18:39:23 -0400
Received: from mail.tmr.com ([64.65.253.246]:58608 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767388AbXDEWjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 18:39:22 -0400
Message-ID: <46157AF7.1070906@tmr.com>
Date: Thu, 05 Apr 2007 18:40:55 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mockern@yandex.ru
CC: linux-kernel@vger.kernel.org
Subject: Re: Question: half-duplex and full-duplex serial driver
References: <4607D065.000004.05517@ariel.yandex.ru>
In-Reply-To: <4607D065.000004.05517@ariel.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mockern wrote:
> Hi,
> 
> Could you help me please, how can my serial driver to work in  half-duplex and full-duplex mode?
> 
> Thank you

Since you don't seem to have gotten an answer, and while this is 
probably the wrong list for your question, I can give you a pointer 
which may help.

The communications program "kermit" can do this, google for the source, 
or try kermit.columbia.edu first, and read the source to see how they do 
it. I'm reasonably sure ioctl() is the answer, but that's choice three 
for your research.

-- 
bill davidsen <davidsen@tmr.com>
   CTO TMR Associates, Inc
   Doing interesting things with small computers since 1979
