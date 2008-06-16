Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbYFPRKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbYFPRKS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYFPRKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:10:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43645 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbYFPRKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:10:05 -0400
Message-ID: <48569D96.1090904@zytor.com>
Date: Mon, 16 Jun 2008 10:06:30 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com>
In-Reply-To: <20080616161944.GA53539@atlantis.8hz.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> 
>> What bootloader does this platform use?  I wonder if it's setting things 
>> up in an unexpected way?
> 
> It's syslinux. That must be the culprit, considering the change to head_32.S.
> 
> I'm digging in syslinux right now. 
> 

What makes you draw that conclusion?

	-hpa
