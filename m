Return-Path: <linux-kernel-owner+w=401wt.eu-S1765372AbXJPRGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765372AbXJPRGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbXJPRGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:06:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:53766 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbXJPRGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:06:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=ga1zuVsyOF0cjQOuIoSSR4SLvHX7MRLGUfSYyRY/QBUDUHXzKD2yaIgRvi4XbbRpEVjKUSbrPq3089eFl1ewrwyY9yz8z8JjecJ9/V2vYF1hgdwLnwnsx6LYAYx1YyWGWGFSiHBP5UagbmpRT0ssX3+4YZfsed3XrdihLgqEmGY=
Message-ID: <4714EF81.2070405@gmail.com>
Date: Tue, 16 Oct 2007 21:06:09 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: Dick Johnson <linux-os@analogic.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, robert.moore@intel.com,
       len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr> <4714979C.5010103@free.fr> <Pine.LNX.4.61.0710160835160.11232@chaos.analogic.com> <4714B7D7.7090005@free.fr>
In-Reply-To: <4714B7D7.7090005@free.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

>          +===================================+
>          | Soft-Off by PWR-BTTN              |
>          |-----------------------------------|
>          | Instant-Off  ..... [v]            |
>          | Delay 4 Sec. ..... [ ]            |
>          |                                   |
>          |-----------------------------------|
>          |  ^V:Move ENTER:Accept ESC:Abort   |
>          +===================================+
> 
> 'Instant-Off' is the appropriate setting, right?
Actually, default should be 4 sec delay. OS should have 
a chance to shut down the system...

