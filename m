Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYKDG0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYKDG0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 01:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbYKDG0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 01:26:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:33996 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbYKDG0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 01:26:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=TxDBHyVC4UuVRw7xW+R5QtGLMtjFDm2NeJzs0MA/Ub6O4KakwThtPkjjk2AUgCBTO
	tlLwxkabbA/Fqu5pls9EQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830811032225w229d3a29k17b9a38cb76a521f@mail.gmail.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	 <20081101184824.2575.5935.sendpatchset@balbir-laptop>
	 <6599ad830811032225w229d3a29k17b9a38cb76a521f@mail.gmail.com>
Date: Mon, 3 Nov 2008 22:26:19 -0800
Message-ID: <6599ad830811032226h4c4a81d4hb030953a4e0906db@mail.gmail.com>
Subject: Re: [mm] [PATCH 1/4] Memory cgroup hierarchy documentation
From: Paul Menage <menage@google.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2008 at 10:25 PM, Paul Menage <menage@google.com> wrote:
>
> That's not a very intuitive interface. Why not memory.use_hierarchy?

Or for consistency with the existing cpuset.memory_pressure_enabled,
just memory.hierarchy_enabled ?

Paul
