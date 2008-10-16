Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYJPLbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYJPLbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYJPLbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:31:23 -0400
Received: from forwards6.yandex.ru ([77.88.61.38]:59005 "EHLO
	forwards6.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYJPLbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:31:23 -0400
X-Yandex-Spam: 1 
X-Yandex-Front: smtp4
X-Yandex-TimeMark: 1224156672
X-MsgDayCount: 3
X-Comment: RFC 2476 MSA function at smtp4.yandex.ru logged sender identity as: dmantipov
Message-ID: <48F725FF.6000709@yandex.ru>
Date: Thu, 16 Oct 2008 15:31:11 +0400
From: Dmitry Antipov <dmantipov@yandex.ru>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.27: 0 MHz CPU and wrong system time on AMD Geode system
References: <414861224052797@webmail58.yandex.ru> <20081015162143.GA19397@cosmic.amd.com>
In-Reply-To: <20081015162143.GA19397@cosmic.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jordan Crouse wrote:

> Hmmm - this is an interesting regression.  Please remove
> CONFIG_GEODE_MFGPT_TIMER=y from your 2.6.27 kernel and see if the
> problem goes away. 

Unfortunately it doesn't help.

> I have been running 2.6.26.5 on my system with no problems, but I'm
 > embarrassed to admit that I haven't run anything newer in a while.

What system do you have?

Dmitry
