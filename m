Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYIXIoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYIXIoj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIXIob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:44:31 -0400
Received: from pih-relay08.plus.net ([212.159.14.20]:53018 "EHLO
	pih-relay08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbYIXIob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:44:31 -0400
Message-ID: <48D9FDF3.4000008@yahoo.com>
Date: Wed, 24 Sep 2008 09:44:35 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
User-Agent: Thunderbird 2.0.0.16 (Macintosh/20080707)
MIME-Version: 1.0
To: Jeroen van Rijn <jvrnix@gmail.com>
CC: gshan <gshan@alcatel-lucent.com>, linux-kernel@vger.kernel.org
Subject: Re: Create real-time process from shell script
References: <48D99E0D.9000003@alcatel-lucent.com> <8ee0b8e80809240054r7197072exde7f75e47f56f120@mail.gmail.com>
In-Reply-To: <8ee0b8e80809240054r7197072exde7f75e47f56f120@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Plusnet-Relay: 44edee81bd396d416aa68996e8a07bbe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen van Rijn wrote:
> On Wed, Sep 24, 2008 at 3:55 AM, gshan <gshan@alcatel-lucent.com> wrote:
>> Hello, Is there any way (or linux utilities) could be used to create a
>> real-time process in shell script?

> nice -20 <command> <args>

If you prefer realtime scheduling (as in SCHED_FIFO etc) you may want to 
look at chrt (but this isn't really a linux kernel question so this 
might be the wrong list to ask).

-- 
Sitsofe | http://sucs.org/~sits/
