Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842Ab0A0CkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0A0CkM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:40:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678Ab0A0CkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:40:10 -0500
Received: from smtp-out3.blueyonder.co.uk ([195.188.213.6]:49602 "EHLO
	smtp-out3.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897Ab0A0CkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:40:09 -0500
Message-ID: <4B5FA785.3010002@blueyonder.co.uk>
Date: Wed, 27 Jan 2010 02:40:05 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.14 Thunderbird/3.0 ThunderBrowse/3.2.7
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: HDA Intel Audio hang on boot
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <201001261922.35213.rjw@sisk.pl> <4B5F5777.8070701@blueyonder.co.uk> <201001270156.46217.rjw@sisk.pl>
In-Reply-To: <201001270156.46217.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/10 00:56, Rafael J. Wysocki wrote:
> On Tuesday 26 January 2010, Sid Boyce wrote:
>> I forgot to mention 2.6.33-rc5 now boots successfully.
> 
> Does that mean the problem is fixed in 2.6.33-rc5 or you still need the
> enable_msi=0 workaround?
> 
> Rafael
> 
It boots only with the enable_msi=0 workaround.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

