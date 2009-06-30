Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241AbZF3QS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbZF3QS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 12:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZF3QSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 12:18:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZF3QST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 12:18:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nTKIe6dP/QMD5O994XU6gT5y4Io3mCcpZoMP2Gs3vgZpBFIOgV07OzawiZWNL0ziu
	t5AeOGAhQo9TAh3ZCP2LA==
MIME-Version: 1.0
In-Reply-To: <20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090630180109.f137c10e.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090630180344.d7274644.kamezawa.hiroyu@jp.fujitsu.com>
	 <6599ad830906300215q56bda5ccnc99862211dc65289@mail.gmail.com>
	 <20090630182304.8049039c.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 30 Jun 2009 09:18:03 -0700
Message-ID: <6599ad830906300918i3e3f8611r6d6fb7873c720c70@mail.gmail.com>
Subject: Re: [PATCH 2/2] cgroup: exlclude release rmdir
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 2:23 AM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> This patch is _not_ tested by Nishimura.

True, but it's functionally identical to, and simpler than, the one
that was tested.

Paul
