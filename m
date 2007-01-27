Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbXA0Io3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbXA0Io3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXA0Io3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:44:29 -0500
Received: from weequay.is.scarlet.be ([193.74.71.24]:58818 "EHLO
	weequay.is.scarlet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXA0Io2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:44:28 -0500
Message-ID: <45BB106E.706@joow.be>
Date: Sat, 27 Jan 2007 09:42:22 +0100
From: Pieter Palmers <pieterp@joow.be>
User-Agent: Thunderbird 1.5.0.2 (X11/20060501)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux1394-Devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: 2.6.20-rc6-rt2: kernel oops when ejecting cardbus firewire card
References: <45BA743B.2080401@joow.be> <45BA85A1.1030707@s5r6.in-berlin.de>
In-Reply-To: <45BA85A1.1030707@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DCC-scarlet.be-Metrics: weequay 20001; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Pieter Palmers wrote:
>> cc'ing linux1394-devel because it seems to be a problem in the ieee1394 
>> stack.
> 
> Yes, this bug is in stock Linux 2.6 too. Ever has been.
> http://bugzilla.kernel.org/show_bug.cgi?id=7121
Oops, missed that. Sorry for the noise.

Pieter
