Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbYC2WWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbYC2WWj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYC2WWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:22:31 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47302 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbYC2WWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:22:30 -0400
Message-ID: <47EEC187.1020707@keyaccess.nl>
Date: Sat, 29 Mar 2008 23:24:07 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Richard Jonsson <richie@coderworld.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net> <47EEB2F8.40907@keyaccess.nl> <47EEBE9F.6080605@coderworld.net>
In-Reply-To: <47EEBE9F.6080605@coderworld.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-03-08 23:11, Richard Jonsson wrote:

>> Does the weirdness persist if you boot with "io_delay=0x80" as a 
>> kernel parameter? (it should if -rc3 really was fine, but...)
> 
> I'm testing that param at the moment, and while writing this response it 
> happened again, meaning it didn't change anything..

Okay, expected, but the "HP dvXXXX" triggered the reply.

> I can't say for sure rc3 wasn't affected, I just never noticed the 
> behavior during the 2-3 weeks I used it.

Haven't been following the list lately, but I believe I read something about 
a scheduler / X.org interaction problem. Afraid that's all from me though...

Rene.
