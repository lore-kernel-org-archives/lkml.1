Return-Path: <linux-kernel-owner+w=401wt.eu-S1760267AbYCEHFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760267AbYCEHFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbYCEHFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:05:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:4983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbYCEHFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:05:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=HqrKb+vS7A0XjepThfY+WIybI5d1dFK203PF+sFo0e1ZD/4ZQWJXFi2GnaWYm6HWp
	Xt3yXHIaGg6DYvxhoJ/ZA==
Message-ID: <6599ad830803042305t23330f4ib798ee393620387b@mail.gmail.com>
Date: Tue, 4 Mar 2008 23:05:15 -0800
From: "Paul Menage" <menage@google.com>
To: "Kazunaga Ikeno" <k-ikeno@ak.jp.nec.com>
Subject: Re: [RFC][PATCH 0/1]a new optional function for task assignment to cgroup
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <000801c87e8e$d95e2260$cc7d220a@kid0000>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47CE322A.9060907@ak.jp.nec.com>
	 <6599ad830803042156y5a28978fi995eb9050f8f5320@mail.gmail.com>
	 <000801c87e8e$d95e2260$cc7d220a@kid0000>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 4, 2008 at 11:02 PM, Kazunaga Ikeno <k-ikeno@ak.jp.nec.com> wrote:
>
>  Thank you for your comment.
>  Because it was the almost same timing, I did not notice about Dhaval Giani's plan.
>  I will investigate it.

Actually, Dhaval was talking about this last year. His proposal for
libcg doesn't seem to actually mention it, but having a feature like
that in libcg would be good.

Paul
