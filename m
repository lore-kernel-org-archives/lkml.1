Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXLFXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXLFXf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:35:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXLFXfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:35:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44190 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbXLFXfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:35:19 -0500
Date: Thu, 6 Dec 2007 15:34:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: laurent.riffard@free.fr, linux-kernel@vger.kernel.org, roland@redhat.com,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: 2.6.24-rc4-mm1: VDSOSYM build error
Message-Id: <20071206153415.353ddeea.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0712061528j4c0ea529w71bd2b96e1e73043@mail.gmail.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<47587796.8020705@free.fr>
	<20071206143754.07a67819.akpm@linux-foundation.org>
	<a44ae5cd0712061528j4c0ea529w71bd2b96e1e73043@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 18:28:25 -0500
"Miles Lane" <miles.lane@gmail.com> wrote:

> How can I find Roland's patches, so I can try backing them out?
> I looked in the broken out patches and only saw one related
> to VDSO.  Backing it out did not help.  I tried searching for
> messages to LKML sent by "roland" but mostly got a bunch of
> folks sending spam.
> 

They're all clumped into git-x86.patch.  Hard.
