Return-Path: <linux-kernel-owner+w=401wt.eu-S1751659AbZGNASG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbZGNASG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 20:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbZGNASF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 20:18:05 -0400
Received: from smtp-out.google.com ([216.239.33.17]:29628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZGNASE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 20:18:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VlQmYWTNBlbRo9aXjkzYAKDCizv4bZhZfvXbavqSOBkXZTP1kq9RB27gzY5+B9BFS
	9UJ4Fe6s9bQlGDAALtbiQ==
MIME-Version: 1.0
In-Reply-To: <20090713205749.GE2569@elf.ucw.cz>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
Date: Mon, 13 Jul 2009 17:17:58 -0700
Message-ID: <a55d774e0907131717x3df8f9bal679994a552b864de@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 1:57 PM, Pavel Machek<pavel@ucw.cz> wrote:
> Hi!
>
> I'm looking at synaptic touchscreen driver... who should be listed as
> an author?

Arve.

Arve -- You'll want to look at Pavel's revised synaptics driver, sent to lkml.

Brian
