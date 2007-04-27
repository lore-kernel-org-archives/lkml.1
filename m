Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbXD0Xd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbXD0Xd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 19:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXD0Xd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 19:33:57 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbXD0Xd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 19:33:56 -0400
Message-ID: <4632885F.4080600@zytor.com>
Date: Fri, 27 Apr 2007 16:33:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com> <46314A08.9000209@redhat.com> <46314AAD.9010300@zytor.com> <46314C3B.3040908@redhat.com> <4632842F.20101@zytor.com> <463287B2.7070100@redhat.com>
In-Reply-To: <463287B2.7070100@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> H. Peter Anvin wrote:
>> The main use of atime seems to be to figure out when something can be
>> automatically deleted.  Anyone else have other usage scenarios?
> 
> It's not atime which cannot be set, it's ctime.

You're right, my brainfart.

	-hpa
