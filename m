Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXJXMMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXJXMMS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756467AbXJXMMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:12:07 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:48366 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbXJXMMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:12:06 -0400
X-Greylist: delayed 4057 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2007 08:12:06 EDT
Message-ID: <471F2636.20408@cfl.rr.com>
Date: Wed, 24 Oct 2007 07:02:14 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: Mark Hounschell <dmarkh@cfl.rr.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Mark Hounschell <markh@compro.net>
Subject: Re: test_and_set_bit and friends ?
References: <471DC9E8.7040104@cfl.rr.com>
In-Reply-To: <471DC9E8.7040104@cfl.rr.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Hounschell wrote:
> These calls apparently are gone. Can someone tell me why and what are
> the replacements.
> 
> Thanks in advance
> Mark
> 

I got no response from the glibc people on this and the kernel-newbies
list appears dead so I thought I'd try here since these calls are/were
actually kernel based to begin with. Why are they no longer available in
user space and what is one supposed to use now?

Thanks
Mark

