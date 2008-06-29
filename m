Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbYF2QCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbYF2QCh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 12:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753310AbYF2QC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 12:02:27 -0400
Received: from gw.goop.org ([64.81.55.164]:33579 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbYF2QC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 12:02:26 -0400
Message-ID: <4867B20E.2030608@goop.org>
Date: Sun, 29 Jun 2008 09:02:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <4866F6FE.9000503@goop.org> <8763rsphkt.fsf@basil.nowhere.org>
In-Reply-To: <8763rsphkt.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Still there's the effect that Ctrl-Z+kill works faster than Ctrl-C
> that is not explained by this. This has often annoyed me too.
> I'm not sure why it is. In theory they should be the same unless
> someone blocks SIGINT.
>   

I'd never noticed that.  That's just weird.

    J
