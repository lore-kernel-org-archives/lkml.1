Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYBKV5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYBKV5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYBKV50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:57:26 -0500
Received: from relay1.sgi.com ([192.48.171.29]:37474 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754827AbYBKV50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:57:26 -0500
Date: Mon, 11 Feb 2008 15:57:20 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, mel@csn.ul.ie, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/4] mempolicy: support optional mode flags
Message-Id: <20080211155720.7a8a833b.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802111345170.3908@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<1202747811.5014.37.camel@localhost>
	<20080211145543.8821960c.pj@sgi.com>
	<alpine.DEB.1.00.0802111345170.3908@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> With my patchset I don't believe there is any ambiguity in how nodes are 
> numbered anymore.

I'll have to study your patchset more closely tomorrow then.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
