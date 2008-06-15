Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYFOFDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYFOFDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 01:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750926AbYFOFDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 01:03:35 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:34304 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYFOFDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 01:03:34 -0400
Message-ID: <4854A2A4.7090900@keyaccess.nl>
Date: Sun, 15 Jun 2008 07:03:32 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: werner <werner@sys-linux.yi.org>, linux-kernel@vger.kernel.org
Subject: Re: Regressions in the last kernels
References: <1213467969.31034@sys-linux.yi.org> <20080614141805.30cf74f0@infradead.org>
In-Reply-To: <20080614141805.30cf74f0@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-06-08 23:18, Arjan van de Ven wrote:

> On Sat, 14 Jun 2008 15:26:09 -0300 (GFT)
> "werner" <werner@sys-linux.yi.org> wrote:

>> 1) When compiling for i486,  one cannot select/configurate more
>> memory than 4 GB, menuconfig don't show items with higher values.  My
>> own computer/server has 8 GB, but when I compile the kernel with 4 GB
>> and i486 then 'free' shows only 3.2 GB (no shared grafics, the grafic
>> card has its own memory) ...
> 
> 
> interesting problem... 486's didn't have PAE so are limited to 4Gb of
> memory... makes this a policy question more than a bug...
> (in fact, if you configure for > 4Gb a 486 CPU will not boot... so
> arguably the new behavior is correct!!!)

What's arguable about it?

Rene.
