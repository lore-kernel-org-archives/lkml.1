Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYC2VUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYC2VUc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 17:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755121AbYC2VUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 17:20:25 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:44301 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755055AbYC2VUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 17:20:25 -0400
Message-ID: <47EEB2F8.40907@keyaccess.nl>
Date: Sat, 29 Mar 2008 22:22:00 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Richard Jonsson <richie@coderworld.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: Keyboard weirdness: keys get stuck
References: <47EEA097.5000701@coderworld.net>
In-Reply-To: <47EEA097.5000701@coderworld.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-03-08 21:03, Richard Jonsson wrote:

> With 2.6.25-rc6-git-something I have experienced stuck keys. When typing 
> a  sentence a character repeats aboooooooout 10 times, or as 'about' 
> above ;). I tested with a new kernel today, 2.6.25-rc7-git-something and 
> the problem is still present.
> 
> With 2.6.25-rc3 the keyboard is fine, and I've not tried with any kernel 
> in between.
> 
> As a side note, timestamps gets mixed up in dmesg output in a 1-2 second 
> span. Maybe related?
> 
> This is on a HP dv2140eu laptop, x86_64 SMP. Please cc me if you want 
> configuration details or testing to be done.

Does the weirdness persist if you boot with "io_delay=0x80" as a kernel 
parameter? (it should if -rc3 really was fine, but...)

Rene.
