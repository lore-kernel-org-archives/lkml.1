Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbXLHW7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbXLHW7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 17:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbXLHW7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 17:59:33 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:5546 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbXLHW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 17:59:32 -0500
Message-ID: <cccedfc60712081459u764de23ck953750fbdb391d16@mail.gmail.com>
Date: Sat, 8 Dec 2007 16:59:30 -0600
From: "Jon Nelson" <jnelson@jamponi.net>
To: "Ed L. Cashin" <ecashin@coraid.com>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       nickpiggin@yahoo.com.au, clameter@sgi.com, linux-kernel@vger.kernel.org,
       rjw@sisk.pl, a.p.zijlstra@chello.nl
In-Reply-To: <20071203234228.GG27094@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	 <20071201122302.10dd9c44.akpm@linux-foundation.org>
	 <20071203162137.GB25251@coraid.com>
	 <20071203113459.d36c1a01.akpm@linux-foundation.org>
	 <20071203210005.GB27094@coraid.com>
	 <20071203213837.GE27094@coraid.com>
	 <20071203144722.4188f476.akpm@linux-foundation.org>
	 <20071203151349.0ebf497c.akpm@linux-foundation.org>
	 <20071203234228.GG27094@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that 2.6.24rc4 with the (second) patch works fine.
-- 
Jon
