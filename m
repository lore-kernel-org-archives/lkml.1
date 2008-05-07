Return-Path: <linux-kernel-owner+w=401wt.eu-S1761326AbYEGCPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326AbYEGCPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 22:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbYEGCPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 22:15:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:2678 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbYEGCPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 22:15:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hIr8rJ4gb1sY8djLQMv7oMesVzT0yfcWWqisSqRj9VfjzAvCUfKFzo3iWxsqHplT2
	aVkhoq3XBt4/4VcNJUJXw==
Message-ID: <6599ad830805061915s2525e48fw369e7c1aff167a76@mail.gmail.com>
Date: Tue, 6 May 2008 19:15:27 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
Cc: "Andrew Morton" <akpm@linux-foundation.org>, lizf@cn.fujitsu.com,
       seto.hidetoshi@jp.fujitsu.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080506211121.e82bb51a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210101.1070205@google.com>
	 <20080506183841.e1771032.akpm@linux-foundation.org>
	 <482109E5.5050204@cn.fujitsu.com> <20080506204946.7754302d.pj@sgi.com>
	 <6599ad830805061851n767ff7a1qc8cb850ec98ad60d@mail.gmail.com>
	 <20080506205852.8adaa0a2.pj@sgi.com>
	 <20080506190809.df1b9398.akpm@linux-foundation.org>
	 <20080506211121.e82bb51a.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 6, 2008 at 7:11 PM, Paul Jackson <pj@sgi.com> wrote:
> Andrew wrote:
>  > Paul should drop sched-devel.
>
>  I hope that refers to Paul M.

I'm building against 2.6.26-rc1, and don't see those warnings (or any
useful code at those lines). It's probably more fallout from the
cpuset files changes?

Paul
