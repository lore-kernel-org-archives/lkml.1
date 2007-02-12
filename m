Return-Path: <linux-kernel-owner+w=401wt.eu-S1030469AbXBLXS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030469AbXBLXS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030472AbXBLXS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:18:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43869 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030469AbXBLXS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:18:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=l2g7jjg/DbxuKXu4EGQr+cbC595zGhSlZuI7OOxIwxArh7KXrcVvjOn7t5LQru2YE
	uabCMcPrt7HcSOnMF1fqg==
Message-ID: <6599ad830702121518w7e02f51fv93391bed059141d7@mail.gmail.com>
Date: Mon, 12 Feb 2007 15:18:20 -0800
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
Cc: "Sam Vilain" <sam@vilain.net>, akpm@osdl.org, pj@sgi.com,
       sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, winget@google.com,
       rohitseth@google.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070212224717.GB19604@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070212081521.808338000@menage.corp.google.com>
	 <45D0EC68.9090009@vilain.net>
	 <20070212224717.GB19604@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
> Well it's an unfortunate conflict, but I don't see where we have any
> standing to make Paul change his terminology  :)

I have no huge problem with changing my terminology in the interest of
wider adoption. "Container" seems like an appropriate name for the
abstraction, and possibly more appropriate than for a virtual server,
but if it was decreed that the only thing stopping the container patch
being merged was that it should be called, say, "Process Sets", I
would happily s/container/pset/g across the entire patchset.

Paul
