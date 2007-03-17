Return-Path: <linux-kernel-owner+w=401wt.eu-S2992489AbXCQBYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992489AbXCQBYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 21:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966014AbXCQBYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 21:24:51 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:29356 "EHLO
	asav03.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966011AbXCQBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 21:24:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AusRAIbg+kVKhRO4UGdsb2JhbACBZ4VMiCABASo
From: Dmitry Torokhov <dtor@insightbb.com>
To: Victor Fernandes <Victor.Fernandes@comnet.be>
Subject: Re: New kernel mouse recognition problem
Date: Fri, 16 Mar 2007 21:24:49 -0400
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <63140.87.244.133.121.1174080813.squirrel@postino>
In-Reply-To: <63140.87.244.133.121.1174080813.squirrel@postino>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703162124.49789.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Victor,

On Friday 16 March 2007 17:33, Victor Fernandes wrote:
> Dear kernel gurus,
> 
> I have a long experience with linux but not at the kernel level, so my
> apologies if this post is not appropriate for the list, but it seemed to
> me to be the only possible one to post my question.
> 
> Obviously I've also tried to find the solution on the archives (and more)
> but found nothing appropriate.
> 
> Problem: It appears that the new kernels, I've actually kernel 2.6.17-5
> (Mandriva 2007) installed, and tested others on the 2.6.x range, do not
> recognition my "Track Point" mouse anymore. I have on the boot logs
> (syslog) the following message: "logips2pp: Detected unknown logitech
> mouse model 0".
> 

Does the mouse still work despite this message?

> The same system with a kernel 2.6.12-12 (Mandriva 10.1) worked properly.
> 

How was it identified by 2.6.12? Could you please send me output of
cat /proc/bus/input/devices on 2.6.12 and 2.6.17?

-- 
Dmitry
