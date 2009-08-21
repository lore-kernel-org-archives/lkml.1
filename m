Return-Path: <linux-kernel-owner+w=401wt.eu-S1752444AbZHUE6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbZHUE6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 00:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZHUE6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 00:58:51 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZHUE6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 00:58:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=TXFTgzAe19QvHR2Jd6c2+baqzvC3fRLhw/jHLPar7TCnG1pzr/fv0kGH+OIeiQzvy
	3RS77BRe8jZ2Q80xTtVSA==
MIME-Version: 1.0
In-Reply-To: <20090820215007.0e774abb.akpm@linux-foundation.org>
References: <20090818235059.22531.42618.stgit@menage.mtv.corp.google.com>
	 <20090818235843.22531.57310.stgit@menage.mtv.corp.google.com>
	 <4A8CB750.7040509@cn.fujitsu.com>
	 <6599ad830908191945k7c5f86b6j3ea4194f0dffa9ce@mail.gmail.com>
	 <20090820141356.1bec84ed.akpm@linux-foundation.org>
	 <20090821042403.GA25865@andrew.cmu.edu>
	 <20090820215007.0e774abb.akpm@linux-foundation.org>
Date: Thu, 20 Aug 2009 21:58:46 -0700
Message-ID: <6599ad830908202158j3578b6a5n2de699fbbf7bf8f0@mail.gmail.com>
Subject: Re: [PATCH 7/8] Adds functionality to read/write lock CLONE_THREAD 
	fork()ing per-threadgroup
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Blum <bblum@andrew.cmu.edu>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 9:50 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> I was actually referring to the non-ascii crap in the email.
>
> 'twas Paul.
>

Hmm, so it was. It's sad how much gmail seems like like mangling ascii
patches ...

Paul
