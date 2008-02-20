Return-Path: <linux-kernel-owner+w=401wt.eu-S1763716AbYBTFYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763716AbYBTFYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758493AbYBTFXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:23:45 -0500
Received: from smtp-out.google.com ([216.239.33.17]:15823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757355AbYBTFXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:23:43 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=O6KXu9t7PmG7xWuwijsy/W2Qqqr8JL/w1sUwJkG3VU5w+uPjT//8gWsYVF461y0vo
	yVojf4Bf7aJIGuWHswx/Q==
Message-ID: <6599ad830802192123m66c388f5v3916d979f320234e@mail.gmail.com>
Date: Tue, 19 Feb 2008 21:23:33 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com, balbir@in.ibm.com,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080219231726.4bd97520.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204820.734926000@menage.corp.google.com>
	 <47B6B5CA.7040201@linux.vnet.ibm.com>
	 <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
	 <47B953A8.9030206@cn.fujitsu.com> <20080219155742.0298f25f.pj@sgi.com>
	 <6599ad830802191851l66281e67rb49c766c2b1427c9@mail.gmail.com>
	 <20080219231726.4bd97520.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 9:17 PM, Paul Jackson <pj@sgi.com> wrote:
>
> Perhaps my primary concern with these *.api files was that I did not
> understand who or what the critical use or user was; who found this
> essential, not just nice to have.
>

Right now, no-one would find it essential. If/when a binary API is
added, I guess I'll ressurrect this part of the patchset.

Paul
