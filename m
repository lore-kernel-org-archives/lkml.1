Return-Path: <linux-kernel-owner+w=401wt.eu-S933661AbYEIAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbYEIAIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYEIAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:08:22 -0400
Received: from gw.goop.org ([64.81.55.164]:48047 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbYEIAIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:08:21 -0400
Message-ID: <482395ED.8010108@goop.org>
Date: Fri, 09 May 2008 01:08:13 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
References: <20080509084248.43B5.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4823928D.7080907@goop.org> <20080509085731.43BD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080509085731.43BD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Yeah, you are right.
> but it is no regression.
> I agree with my plan have improve chance, but it is better than current.
>   

Sure.  I was just curious and wondered if you'd already looked at it.

    J

