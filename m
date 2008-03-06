Return-Path: <linux-kernel-owner+w=401wt.eu-S935617AbYCFVat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935617AbYCFVat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935375AbYCFVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:30:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935267AbYCFVa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:30:28 -0500
Message-ID: <47D06265.8030305@zytor.com>
Date: Thu, 06 Mar 2008 13:30:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Pawel Plociennik <paplociennik@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>
In-Reply-To: <20080306212028.GB1747@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
> This really should be in kernel, I should not have to partition my
> disk to get booting to few different distros.
> 

Use a small initramfs.  That's the Right Thing to do in the first place.

	-hpa
