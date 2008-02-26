Return-Path: <linux-kernel-owner+w=401wt.eu-S1759888AbYBZGTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759888AbYBZGTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYBZGTi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:19:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYBZGTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:19:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Q1RmR3byS803nBI+D254rYt1RoZcRAUiVG/MvATPZ1mrvhqSBEILEw2EGS/ddVXtt
	eNUCqi3fISwupvo/mB/CA==
Message-ID: <6599ad830802252219p77f41917u7c6c137c8e5448e0@mail.gmail.com>
Date: Mon, 25 Feb 2008 22:19:28 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 00/10] CGroup API files: Various cleanup to CGroup control files
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
In-Reply-To: <47C3862D.8080603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080223224725.115590000@menage.corp.google.com>
	 <47C3862D.8080603@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2008 at 7:23 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>  Should those pathces be rebased againt 2.6.25-rc3 ?
>

No, because they're against 2.6.25-rc2-mm1, which is already has (I
think) any of the new bits in 2.6.25-rc3 that would be affected by
these patches.

Paul
