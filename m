Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbYFITsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbYFITsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYFITsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:48:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbYFITsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:48:03 -0400
Message-ID: <484D88B2.30309@zytor.com>
Date: Mon, 09 Jun 2008 12:46:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7 - fix
References: <200805041823.57198.yhlu.kernel@gmail.com>	 <200805251600.26325.yhlu.kernel@gmail.com>	 <200806011317.38622.yhlu.kernel@gmail.com>	 <200806081953.26877.yhlu.kernel@gmail.com>	 <20080609101318.GA23873@elte.hu>	 <86802c440806091051j30ac4480oe6be0a7b288f772c@mail.gmail.com>	 <20080609190911.GA20997@elte.hu> <86802c440806091238o30ca6910w93163f45fd1419ae@mail.gmail.com>
In-Reply-To: <86802c440806091238o30ca6910w93163f45fd1419ae@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> VISWS or VOYAGER depends on !PCI, that is some odd system.
> 

Both are long-since obsolete systems.

	-hpa
