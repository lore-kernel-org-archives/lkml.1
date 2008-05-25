Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYEYQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYEYQpJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbYEYQos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 12:44:48 -0400
Received: from www.tglx.de ([62.245.132.106]:43121 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbYEYQos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 12:44:48 -0400
Date: Sun, 25 May 2008 18:44:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: hpa@zytor.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] tip/x86/nmi nmi-32/64.c merge v3
In-Reply-To: <4838373b.0637560a.7ce5.3f01@mx.google.com>
Message-ID: <alpine.LFD.1.10.0805251842360.3295@apollo.tec.linutronix.de>
References: <4838373b.0637560a.7ce5.3f01@mx.google.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Cyrill Gorcunov wrote:

> This series tries to merge down nmi_32/64.c to nmi.c. It is done by small
> steps in hope it would help to bisect problems (which will appear anyway ;)
> Please review *carefully* since it is NMI what I've touched (and I'm not
> nmi specialist). So I really apreciate _ANY_ comments on this. The series
> is produced over today 'tip' tree branch 'x86/nmi'.

Cyrill,

very good job. I did a short review and found no obvious problems
yet. Will have a closer look when I apply it.

Thanks,
	tglx



