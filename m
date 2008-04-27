Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbYD0DO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbYD0DO7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbYD0DOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:14:52 -0400
Received: from rv-out-0708.google.com ([209.85.198.245]:50447 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754954AbYD0DOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NmEGXoZ4xF2eAPw0Gq3HMQqTq7vXU7AFPx+xcv5HdKKBH6x5FoAidGKQlpS5+kb262d1OMDlS+kfqUE1iuiTzWnvBmk8hw/Pb303WfsAaDVLEgkWW2+P5mSH/XAdwOHBaFqoFcEJsmu2XYeQdElxWDlEjIbOse4Cz0l2D/YUgY0=
Message-ID: <86802c440804262014p36c77fe1x54b64e8e44be6b8@mail.gmail.com>
Date: Sat, 26 Apr 2008 20:14:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [RFC git pull] "big box" x86 changes
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, jbarnes@virtuousgeek.org
In-Reply-To: <87bq3ww9ab.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080426185516.GA32364@elte.hu> <87bq3ww9ab.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 3:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Ingo Molnar <mingo@elte.hu> writes:
>  >
>  > Most of the work has been done by Yinghai Lu who has gone through a
>  > heroic effort to fix all the big-box bugs that he encountered on the
>  > vanilla Linux kernel on his various up to 256 GB RAM test-systems. Also
>  > work is included from Ying Huang for those insane SGI UV boxes.
>
>  Just to make things clear for the list readers, x86-64 worked fine for years
>  on 256GB systems.

Are you sure? I don't know who had 256g ram with x86-64 that earlier.
Horus from newisys?

that mean 8 sockets * 8 dimms * 4G.

YH
