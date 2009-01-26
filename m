Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZAZV7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZAZV7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbZAZV7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:59:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZAZV7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:59:13 -0500
Message-ID: <497E3222.2060301@zytor.com>
Date: Mon, 26 Jan 2009 13:58:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: devpts multiple instances feedback
References: <20090103155209.GA17988@lst.de> <20090105210940.GA31629@us.ibm.com> <20090126215542.GA20760@lst.de>
In-Reply-To: <20090126215542.GA20760@lst.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
>>
>> That was also one of the reasons for the default 000 mode on the pts/ptmx
>> device node
> 
> So just make it 000 but always created it.
> 

That's what we do...

	-hpa
