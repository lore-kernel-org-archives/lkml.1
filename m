Return-Path: <linux-kernel-owner+w=401wt.eu-S1753863AbZBCXk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbZBCXk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 18:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZBCXks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 18:40:48 -0500
Received: from smtp-out.google.com ([216.239.33.17]:53695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZBCXkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 18:40:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=MgguqXE9HyOGtBQLjWxkD78UECUqkGnr5x0208GpR3xBUjsagat580Hpe8UfLPo/2
	I89q9Xz7doDz3CeOC/h/g==
MIME-Version: 1.0
In-Reply-To: <20090204003847.308cd0df@sbs173>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	 <20090202214153.GV3643@vespa.holoscopio.com>
	 <20090203102416.GA8886@redhat.com> <87ljsnzo4v.fsf@benfinney.id.au>
	 <1233671913.8902.53.camel@abacate.horta>
	 <6599ad830902030855h1753f4a4o3a303b4dbddf10de@mail.gmail.com>
	 <20090203184915.GA10004@glandium.org>
	 <20090203185117.GB3359@mini-me.seanius.net>
	 <6599ad830902031114t7de1b570p4ed5ec497e2e150e@mail.gmail.com>
	 <20090204003847.308cd0df@sbs173>
Date: Tue, 3 Feb 2009 15:40:39 -0800
Message-ID: <6599ad830902031540ra4e00dejd844d584b0668a6e@mail.gmail.com>
Subject: Re: cgroup mount point
From: Paul Menage <menage@google.com>
To: Harald Braumann <harry@unheit.net>
Cc: sean finney <seanius@seanius.net>, Gustavo Noronha <kov@debian.org>,
       debian-devel@lists.debian.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.35
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 3, 2009 at 3:38 PM, Harald Braumann <harry@unheit.net> wrote:
>
> So, what's the problem with /dev/cgroups then? If shm/ and pts/
> are allowed under /dev, wouldn't it be discriminating against
> cgroups/, to not allow it there?

Right, that's what I proposed a couple of emails earlier in this thread.

Paul
