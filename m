Return-Path: <linux-kernel-owner+w=401wt.eu-S1751799AbZLUXsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbZLUXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZLUXs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:48:29 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:36496 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751702AbZLUXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:48:28 -0500
Message-ID: <4B300912.5060905@lougher.demon.co.uk>
Date: Mon, 21 Dec 2009 23:47:30 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bruno Wolff III <bruno@wolff.to>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       phillip.lougher@gmail.com, tim.bird@am.sony.com
Subject: Re: [PATCH 0/9] Squashfs: Add support for LZMA compressed filesystems
References: <E1NHZ6K-00029J-Sw@dylan.lougher.demon.co.uk> <20091221231645.GA32141@wolff.to>
In-Reply-To: <20091221231645.GA32141@wolff.to>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Wolff III wrote:
> On Mon, Dec 07, 2009 at 08:37:48 +0000,
>   Phillip Lougher <phillip@lougher.demon.co.uk> wrote:
>> Hi,
>>
>> The following patches add LZMA decompression support to Squashfs, using the
>> in-kernel LZMA decompression library.
> 
> Do these still have a chance to make 2.6.33?
> 

It's very unlikely.  Andrew wanted it to spend a cycle in linux-next.  I'll then
try for 2.6.34 merge.  I'm happy with that.

Phillip

