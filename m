Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXA3TBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXA3TBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:01:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXA3TBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:01:36 -0500
Received: from vulpecula.futurs.inria.fr ([195.83.212.5]:34224 "EHLO
	vulpecula.futurs.inria.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXA3TBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:01:36 -0500
Message-ID: <45BF960E.1080107@tremplin-utc.net>
Date: Tue, 30 Jan 2007 20:01:34 +0100
From: Eric Piel <Eric.Piel@tremplin-utc.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.name>
Cc: Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       gregkh@suse.de
Subject: Re: [PATCH] Fix /sys/device/.../power/state regression
References: <20061219185223.GA13256@srcf.ucam.org> <20070127131728.GB3942@ucw.cz> <45BF91CA.9030609@tremplin-utc.net> <200701301947.11181.oliver@neukum.name>
In-Reply-To: <200701301947.11181.oliver@neukum.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

01/30/2007 07:47 PM, Oliver Neukum wrote/a écrit:
> Am Dienstag, 30. Januar 2007 19:43 schrieb Eric Piel:
> 
>> I have been using this interface for a _long_ time (before june 2005, cf 
>> http://marc.theaimsgroup.com/?l=linux-usb-devel&m=111869558800526&w=2) 
>> and for different things than power saving: I can turn off my (usb) 
>> optical mouse when watching a movie or going to bed.
>>
>> Is there any hardware independent alternative to turn off USB devices?
> 
> Would you test a patch for autosuspension of hid devices?
> 
Sure, that sounds pretty interesting :-)

Eric

