Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbZGASRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbZGASRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbZGASRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:17:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:23185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbZGASRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:17:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PTnUbQJQKchE7HWm6Aejbh4oxwcFHjsyRuTF8l10QbibWkDxvcQ9q/38tFWYz7YnB
	9hDmhbug8Oc/MKVw3UFSg==
MIME-Version: 1.0
In-Reply-To: <20090701100412.d59122d9.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	 <20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
	 <20090701084037.2c3f53f7.nishimura@mxp.nes.nec.co.jp>
	 <20090701090959.4cbdb03e.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906301727wcb6b292uc3c46451f8844392@mail.gmail.com>
	 <20090701100412.d59122d9.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 11:17:09 -0700
Message-ID: <6599ad830907011117k6cbe0696qffa36401cc23d079@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 6:04 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>
> BTW, do you have patches for NOOP/signal cgroup we discussed a half year ago ?
>

Yes - very nearly ready. They were sitting gathering dust for a while,
but I've just been polishing them up again this week and am planning
to send them out this week or next.

Paul
