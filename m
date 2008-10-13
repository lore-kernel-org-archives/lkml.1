Return-Path: <linux-kernel-owner+w=401wt.eu-S1761844AbYJMN23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761844AbYJMN23 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757136AbYJMN2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:28:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407AbYJMN2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=QFyt1n8Mmrs2lGVm6Nav/q8Be/yHmERqnDEAI9raq42qYiXHLAal/pOouRMXDEPQg4
         +lRtdDwRSoiNNHK2bdx6N00bSYJqv9vfG5W2u9QzmJwyuQ9GHVBBcFL0Y8YD5LkTxqCg
         ScLBwt6s2bDRlktAg4l9lR24qyDSFGXSTgVNc=
From: Eric Lacombe <goretux@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [x86_64] Implementation differences compared to x86_32
Date: Mon, 13 Oct 2008 15:28:17 +0200
User-Agent: KMail/1.9.9
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
References: <200810131426.20075.goretux@gmail.com> <87vdvwr6k9.fsf@basil.nowhere.org>
In-Reply-To: <87vdvwr6k9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810131528.17115.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 October 2008 15:03:02 Andi Kleen wrote:
> Eric Lacombe <tuxiko@free.fr> writes:
> > - In x86_32, the physical memory is mapped on kernel land by way of 4 MB
> > pages.
> > But for x86_64, I read that the physical memory was mapped by way of 4 KB
> > pages. Is it true ? and in this case, why this choice ?
>
> It's normally not true (except in some special circumstances)

What are these particular circumstances ?

	Eric

