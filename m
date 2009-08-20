Return-Path: <linux-kernel-owner+w=401wt.eu-S1753130AbZHTDOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbZHTDOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 23:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbZHTDOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 23:14:03 -0400
Received: from smtp-out.google.com ([216.239.45.13]:18137 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZHTDOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 23:14:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=fdhsjMsApYh7TzpNDU9l/O2D5+oD/OUB3foU8b6INeNSoLV3L1v6MXUGcqhyaKmDH
	spqTC/l9aXlJUG+Zeflzw==
MIME-Version: 1.0
In-Reply-To: <4A8CBEDC.6010709@cn.fujitsu.com>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235812.22531.76212.stgit@menage.mtv.corp.google.com>
	 <4A8CB62F.8030504@cn.fujitsu.com>
	 <6599ad830908191941x6ee47d58x295c29f80f8c624c@mail.gmail.com>
	 <4A8CBEDC.6010709@cn.fujitsu.com>
Date: Wed, 19 Aug 2009 20:13:59 -0700
Message-ID: <6599ad830908192013p328a2256o8c807a160e25a9a3@mail.gmail.com>
Subject: Re: [PATCH 1/8] Revert commit 8827c288feb7810185aa7c2e37537202fc709869
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bblum@andrew.cmu.edu,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 19, 2009 at 8:11 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> As you said, the 2 patches differ just in using different var/func
> names, so rebasing shouldn't be hard but maybe a bit boring.
>

Yes - it's a fair amount of work for no real gain.

Paul
