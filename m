Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbXJBXod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbXJBXod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 19:44:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXJBXo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 19:44:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXJBXoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 19:44:25 -0400
Message-ID: <4702D7C0.1090502@zytor.com>
Date: Tue, 02 Oct 2007 16:44:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@in.ibm.com>,
       lguest <lguest@ozlabs.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] Boot protocol changes
References: <1191368052.17826.40.camel@localhost.localdomain>
In-Reply-To: <1191368052.17826.40.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Hi all,
> 
> 	Jeremy had some boot changes for bzImages, but buried in there was an
> update to the boot protocol to support Xen and lguest (and kvm-lite).
> I've copied those fairly simple patches, and if HPA is happy I'd like to
> push them for 2.6.24 (after correcting for the Great Arch Merge of
> course).
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa
