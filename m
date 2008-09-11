Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYIKSfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYIKSfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbYIKSer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:34:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58451 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756385AbYIKSep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:34:45 -0400
Date: 11 Sep 2008 18:41:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: j@jannau.net
Cc: jarod@redhat.com
Cc: jwilson@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: lkml@ml.breakpoint.cc
Cc: superm1@ubuntu.com
Message-ID: <AlfDZmE3jFB@christoph>
In-Reply-To: <200809091153.49184.j@jannau.net>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX18QX8+W1Ptam1mEHAeKL3cDo/sahbFJCZz0fnw
 iPWNNSz5MTbNSB7VCUm5VnMhJsIy8zsomIewuFYvu1lCgFAcBM
 Mp/p13v5NvWtrlW6vrTJWlk+DEmyodPWbToUF2Io/k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janne,

on 09 Sep 08 at 11:53, Janne Grunau wrote:
> On Tuesday 09 September 2008 09:40:18 Sebastian Siewior wrote:
[...]
>>>+EXPORT_SYMBOL(lirc_register_plugin);
>>
>> Is EXPORT_SYMBOL_GPL() possible?

> Afaik yes, all drivers using this symbol are in this patchset and under
> GPL. If it is desireable to to use EXPORT_SYMBOL_GPL() has someone else
> to decide. Christoph?

Please keep EXPORT_SYMBOL().

Christoph
