Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbYC2WL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbYC2WL7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 18:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbYC2WLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 18:11:52 -0400
Received: from proxy1.bredband.net ([195.54.101.71]:36890 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYC2WLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 18:11:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqdlABZb7kdT48OPPGdsb2JhbACBWoZViQoBAQEBMJcd
Message-ID: <47EEBE9F.6080605@coderworld.net>
Date: Sat, 29 Mar 2008 23:11:43 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Rene Herman <rene.herman@keyaccess.nl>
CC: linux-kernel@vger.kernel.org
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net> <47EEB2F8.40907@keyaccess.nl>
In-Reply-To: <47EEB2F8.40907@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman skrev:
> Does the weirdness persist if you boot with "io_delay=0x80" as a kernel 
> parameter? (it should if -rc3 really was fine, but...)

I'm testing that param at the moment, and while writing this response it 
happened again, meaning it didn't change anything..

I can't say for sure rc3 wasn't affected, I just never noticed the 
behavior during the 2-3 weeks I used it.

regards, Richard
