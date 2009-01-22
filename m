Return-Path: <linux-kernel-owner+w=401wt.eu-S1756189AbZAVKvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189AbZAVKvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:51:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZAVKvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:51:44 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:55913 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbZAVKvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:51:43 -0500
Message-ID: <49784F79.1070905@hiramoto.org>
Date: Thu, 22 Jan 2009 11:50:33 +0100
From: Karl Hiramoto <karl@hiramoto.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090102)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Miguel_=C1ngel_=C1lvarez?= <gotzoncabanes@gmail.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: IXP4XX queues
References: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
In-Reply-To: <b0438a630901212342o543ed522p60376f764b6248b5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ángel Álvarez wrote:
> Hi
>
> Last December we talked about 64 queues and IXP4XX. Karl has a patch
> for them, and although I think it could be better to splitt it into
> two different ones ("plain 64 queue expansion" for which I proposed a
> modified patch based on Karl's, and "debugging and other things"), I
> prefer Karl's to none.
>
> What do you think of this? Which should be the best way to include it
> in the main stream kernel?
>
> Thanks
>
> Miguel Ángel
>
>   
The patch needs minor  rework so it  applies cleanly against 2.6.29-rc2 
at the moment i don't have time to do this and test it.


--
Karl
