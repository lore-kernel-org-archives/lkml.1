Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZAZXg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZAZXg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAZXgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:36:48 -0500
Received: from h155.mvista.com ([63.81.120.155]:7460 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752966AbZAZXgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:36:47 -0500
Message-ID: <497E4908.9060705@ru.mvista.com>
Date: Tue, 27 Jan 2009 02:36:40 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <20090125110742.4ba54c0b@lxorguk.ukuu.org.uk> <alpine.DEB.1.10.0901250705300.6888@p34.internal.lan> <alpine.DEB.1.10.0901250715030.10379@p34.internal.lan> <20090126220210.GB26064@csclub.uwaterloo.ca>
In-Reply-To: <20090126220210.GB26064@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Lennart Sorensen wrote:

>> It comes with one :)
>> # xfs_admin -u  /dev/sdd2
>> UUID = 77ae4251-631f-4656-a365-c5723f5c5da8
>>
>> Will try to use this to boot; however, I'd prefer the labels over the 
>> UUID, wish there was an easy way to set it.
>>     
>
> I prefer UUIDs.
>
> Much mroe likely to have the same label on multiple drives than the same
> UUID.

   For example, CentOS 4.3 went crazy in such case, being unable to 
mount anything but root IIRC.

MBR, Sergei


