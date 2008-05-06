Return-Path: <linux-kernel-owner+w=401wt.eu-S932091AbYEFTJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091AbYEFTJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 15:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757011AbYEFTJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 15:09:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36301 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYEFTJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 15:09:05 -0400
Message-ID: <4820ACB5.9060009@zytor.com>
Date: Tue, 06 May 2008 12:08:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fixed mtrr change WP to WB
References: <200805041823.57198.yhlu.kernel@gmail.com>	 <200805061038.58023.yhlu.kernel@gmail.com>	 <200805061041.40047.yhlu.kernel@gmail.com>	 <482099E6.5060208@zytor.com>	 <86802c440805061124w630bc987k71c3c290fdfde773@mail.gmail.com>	 <4820A401.1040105@zytor.com>	 <86802c440805061134y21fbb2a3s872c41c522b9f49f@mail.gmail.com>	 <4820A6DF.7010607@zytor.com> <86802c440805061205lf312e02jb44318e97212d4e1@mail.gmail.com>
In-Reply-To: <86802c440805061205lf312e02jb44318e97212d4e1@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>>  Then you would have to add a method to pass it into the kernel if you want
>> it to be generally useful.
> 
> but how about old stock kernel in RHEL3U9?
> 

There is nothing you can do about those that will work on any platform. 
  If you have knowledge of the firmware you can of course break those rules.

	-hpa
