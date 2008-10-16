Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYJPJk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYJPJk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYJPJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:40:48 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56897 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbYJPJkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:40:47 -0400
Message-ID: <48F70C17.5030202@pobox.com>
Date: Thu, 16 Oct 2008 05:40:39 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: I have returned!
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru> <48F2F138.6020103@kernel.org> <48F34CB9.3020000@pobox.com> <20081013150231.294b38b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20081013150231.294b38b6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I have returned!  muhahahahahaha....
> 
> Oh good..
> --
> 
> ibmtr: PCMCIA IBMTR is ok on 64bit
> 
> From: Alan Cox <alan@redhat.com>
> 
> For whatever value of 'OK' can be applied to the use of token ring. Seems
> the 32bit to 64bit cleanups missed re-enabling the pcmcia driver
> 
> Closes #7133 and also reviewed the code in question
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---
> 
>  drivers/net/pcmcia/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied


