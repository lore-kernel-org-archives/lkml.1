Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYBANZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYBANZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:25:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbYBANZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:25:39 -0500
Received: from wr-out-0506.google.com ([64.233.184.237]:31240 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbYBANZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:25:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=vEiTaUp919FMLu+rYvGBWeMBlxvCQY0GlukkBwk8zNFfEOp0tvBuU6X2vQsFAyfmH8PJG00HDoITF80u7jJZFz4AL85JoESss/XBA7QJNxf1On6Ub4H/GGmspzxNAGhsC6/IuFNwFTqWjoyvT4NsBhBhD3s0fEZ5W5DdDG2gkz4=
Message-ID: <e2e108260802010525r2e371286qb954db1fad88ff24@mail.gmail.com>
Date: Fri, 1 Feb 2008 14:25:34 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       "FUJITA Tomonori" <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp
Subject: Re: Integration of SCST in the mainstream Linux kernel
Cc: "Roland Dreier" <rdreier@cisco.com>, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, vst@vlnb.net,
       linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, "Mike Mazarick" <mazarick@bellsouth.net>
In-Reply-To: <1201867517.11265.294.camel@haakon2.linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <adazluoe2t3.fsf@cisco.com>
	 <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
	 <e2e108260801300038q10132aafs1dbc6e5400fc47bb@mail.gmail.com>
	 <20080130195635T.tomof@acm.org>
	 <1201785938.7280.105.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010011n7c539a0bk2aa3c1d0aa6c00a@mail.gmail.com>
	 <1201862364.11265.267.camel@haakon2.linux-iscsi.org>
	 <e2e108260802010304p304614e9p78b0aca43b24246@mail.gmail.com>
	 <1201867517.11265.294.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 1, 2008 1:05 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
>
> All of the kernel and C userspace code is open source and available from
> linux-iscsi.org and licensed under the GPL.

I found a statement on a web page that the ERL2 implementation is not
included in the GPL version (http://zaal.org/iscsi/index.html). The
above implies that this statement is incorrect. Tomo, are you the
maintainer of this web page ?

I'll try to measure the performance of the LIO Target Stack on the
same setup on which I ran the other performance tests.

Bart Van Assche.
