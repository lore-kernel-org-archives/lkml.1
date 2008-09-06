Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbYIFFxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbYIFFxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 01:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYIFFx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 01:53:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbYIFFx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 01:53:28 -0400
Message-ID: <48C21ACB.5090304@zytor.com>
Date: Fri, 05 Sep 2008 22:53:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Robert Hancock <hancockr@shaw.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes (NOPL issue)
References: <fa.HDZlnwhQIaOU7WkvenWvWDveLiI@ifi.uio.no>	 <fa.uHa5kqSRJ8gj0H3r9BmGsTqRvFI@ifi.uio.no> <48C200F8.90705@shaw.ca>	 <48C201E5.7080703@zytor.com> <86802c440809052250h194a3e7dnd088fa1228dff109@mail.gmail.com>
In-Reply-To: <86802c440809052250h194a3e7dnd088fa1228dff109@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> 
> oh, is the one that is going to fix booting with VirtualBox?
> 

MS Virtual Server/Virtual PC.  VirtualBox seems to be a different 
problem, which seems to be related to not respecting interrupt 
boundaries properly.

	-hpa
