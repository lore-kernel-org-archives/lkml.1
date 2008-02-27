Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbYB0BJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbYB0BJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbYB0BJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:09:26 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYB0BJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:09:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Kk4pXkipXIOP3o3VuGFj2Qy/gExxzzxf5mvELd9fTion6xQu4bU74gJNvBrn52gIG
	xGH2adKUvAj3HyvbF0Gbw==
Message-ID: <6599ad830802261709h15895e68r75ce3004b61428d6@mail.gmail.com>
Date: Tue, 26 Feb 2008 17:09:17 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 00/10] CGroup API files: Various cleanup to CGroup control files
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <47C3C462.4000706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223224725.115590000@menage.corp.google.com>
	 <47C3862D.8080603@cn.fujitsu.com>
	 <6599ad830802252219p77f41917u7c6c137c8e5448e0@mail.gmail.com>
	 <47C3C462.4000706@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 11:48 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>  -rc2-mm1 came out on 2008-02-16, but the patches I posted several days ago
>  has been merged into -rc3, so your patches don't apply now. :(

OK, good point.

>
>  Think about ./MAINTAINERS update and set up a git tree for development of
>  cgroup and cgroup subsystems as Andrew suggested. :)
>

Sounds like a good plan - I'll get on to it ...

Paul
