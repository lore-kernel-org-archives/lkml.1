Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbYCHKkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbYCHKkp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 05:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYCHKki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 05:40:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbYCHKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 05:40:38 -0500
Message-ID: <47D26AE0.40808@zytor.com>
Date: Sat, 08 Mar 2008 11:30:56 +0100
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>
CC: Pavel Machek <pavel@ucw.cz>, Rick van Rein <rick@vanrein.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] mm: BadRAM support for broken memory
References: <20080302134221.GA25196@phantom.vanrein.org>	 <20080303141438.GD12606@elf.ucw.cz> <2f11576a0803030841g43f673d9w6b9a5cc8c6e35340@mail.gmail.com> <47D269AB.2010306@zytor.com>
In-Reply-To: <47D269AB.2010306@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 
> More importantly:
> 
>     memmap=<size>$<len>
> 
> already allows you to knock arbitrary holes in the memory map.
> 

Sorry for the repeats.  I just came off a long flight and didn't 
remember I had already responded to this thread.

	-hpa

