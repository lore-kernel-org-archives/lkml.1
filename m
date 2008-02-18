Return-Path: <linux-kernel-owner+w=401wt.eu-S1759132AbYBRLcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759132AbYBRLcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 06:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757915AbYBRLc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 06:32:27 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:55059 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757625AbYBRLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 06:32:27 -0500
Date: Mon, 18 Feb 2008 12:32:26 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: schwab@suse.de, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
In-Reply-To: <47b96bfb.JBObZ4RAbCByCIvV%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0802181230360.26274@fbirervta.pbzchgretzou.qr>
References: <47b8c177.2QDr0ADTa5ExM+/T%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0802180048320.26274@fbirervta.pbzchgretzou.qr>
 <47b96bfb.JBObZ4RAbCByCIvV%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 18 2008 12:28, Joerg Schilling wrote:
>
>> >This fragment is much too short to allow to judge on possible reasons.
>> >There is a high probability that your problem is caused by the cdrecord
>> >fork called "wodim".
>> >
>> [...]
>> >
>> >As a general advise: if you have problems, always first try recent original 
>> >software from
>>
>> SUSE 10.3 users (and the OP seems to be one..) may use the 'cdrtools' 
>> RPM which I have in my repository (I don't like wodim either, but that's 
>> not the point here). Just !webpin for cdrtools.
>
>Thank you for this hint!
>
>Maybe, you should mention a URL to your repository....

Indeed,
{http,ftp,rsync}://ftp5.gwdg.de/pub/linux/misc/suser-jengelh/SUSE-10.3
There is more than just cdrtools, so people please be aware before
blindly hitting "Global System Upgrade" :)
