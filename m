Return-Path: <linux-kernel-owner+w=401wt.eu-S932206AbYCTAEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbYCTAEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942307AbYCSXDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:03:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:52170 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S942301AbYCSXDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:03:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=azvP84CvH283gmZ6coVBywfcvwcZTt/qkO/EWJTlmxvHTBff5nL0lexG6Xmr3awokZDCpHiIUGUy5ZpPqkWxtBlM3f+uMSicUjSApnDPLtq4/Cuhx1zcJ5Od/EC8G+smqZcnqUQVoCCQORnZSsi4vVs8fLkn/fjvZ02kVhUuR/Q=
Message-ID: <47E19BA1.8010905@gmail.com>
Date: Thu, 20 Mar 2008 00:02:57 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: marcel@holtmann.org, maxk@qualcomm.com, bluez-devel@lists.sourceforge.net,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: bluetooth still corrupts memory in 2.6.25-rc6
References: <20080319082115.GA14543@elf.ucw.cz>
In-Reply-To: <20080319082115.GA14543@elf.ucw.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2008 09:21 AM, Pavel Machek wrote:
> ...just leave ppp-over-cellphone-over-bluetooth running, and do
> s2ram...
> 
> Linux version 2.6.25-rc6 (pavel@amd) (gcc version 4.1.3 20071209 (prerelease) (Debian 4.1.2-18)) #186 SMP Wed Mar 19 00:46:05 CET 2008
> BIOS-provided physical RAM map:

Pavel, does the "still" from $SUBJ mean, that 2.6.24 is affected too (if this is 
the same what I hit)?
