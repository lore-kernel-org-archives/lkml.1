Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXEQSKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXEQSKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 14:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbXEQSKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 14:10:38 -0400
Received: from gw.goop.org ([64.81.55.164]:55823 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXEQSKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 14:10:38 -0400
Message-ID: <464C9A9B.7040608@goop.org>
Date: Thu, 17 May 2007 11:10:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1: strange GPF when panicing under kvm
References: <464B9E19.6050902@goop.org> <464C574C.5020201@qumranet.com> <464C8DBA.80506@goop.org> <464C9126.3090907@qumranet.com>
In-Reply-To: <464C9126.3090907@qumranet.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> That means pause isn't set for interception.
>
> I ran a small test program, and it liked pause as well.
>
> Can you send me your vmlinuz?  I wasn't able top reproduce the problem
> with mine.
>

I can't repro it anymore either.

    J
