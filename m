Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYC0QkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYC0QkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 12:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758679AbYC0QkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 12:40:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41484 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758442AbYC0QkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 12:40:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=FWlocy2zNIoICNllEV0yCEtKizErZ9vFdxHLvqDzpVnl9ykl2ysymIlqc08yA3L6c
	rfr01ixfkndUeueM5VXNQ==
Message-ID: <6599ad830803270940k261e1ae4r15f03f5014d9bec6@mail.gmail.com>
Date: Thu, 27 Mar 2008 09:40:00 -0700
From: "Paul Menage" <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH 1/1] cgroups: implement device whitelist (v6)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, daniel@hozac.com,
       lizf@cn.fujitsu.com, "Pavel Emelyanov" <xemul@openvz.org>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20080327162447.GA15147@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326180543.GA27709@sergelap.austin.ibm.com>
	 <20080327020403.5547e43f.akpm@linux-foundation.org>
	 <20080327162447.GA15147@sergelap.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 9:24 AM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>  Paul, did you have any plans of offering some sort of cft->read_seq()
>  helper?

Yes, it's on my TODO list. It should just be a pretty simple extension
of the existing read_map() support.

Paul
