Return-Path: <linux-kernel-owner+w=401wt.eu-S1756178AbXLBQ5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbXLBQ5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXLBQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:56:52 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:17986 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXLBQ4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:56:52 -0500
Message-ID: <cccedfc60712020856k157192e6u4f2610e5e755c8df@mail.gmail.com>
Date: Sun, 2 Dec 2007 10:56:49 -0600
From: "Jon Nelson" <jnelson@jamponi.net>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9482] New: kernel GPF in 2.6.24 (g09f345da)
Cc: jnelson-kernel-bugzilla@jamponi.net, bugme-daemon@bugzilla.kernel.org,
       "Ed L. Cashin" <ecashin@coraid.com>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20071201122302.10dd9c44.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bug-9482-10286@http.bugzilla.kernel.org/>
	 <20071201122302.10dd9c44.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded to a more recent commit,
92d499d991ec4f5cbd00d6f33967eab9d3ee8d6c
and rebuilt.

Now I get lots and lots of AoE errors, over and over again, but no GPF.

aoe: can't get a frame. This shouldn't happen.

It's possible the previous kernel had been patched, so I made really
REALLY sure that this was a 100% clean build using the above commit. I
can build using more or less any other commit or tag upon request but
it's not quick.

-- 
Jon
