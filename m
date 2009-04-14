Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920AbZDNAv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbZDNAv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 20:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbZDNAvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 20:51:45 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:42537 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753049AbZDNAvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 20:51:45 -0400
In-Reply-To: <20090413165404.b6660aea.akpm@linux-foundation.org>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090413160814.1c335d1d.akpm@linux-foundation.org> <298A09AD-495E-4671-84A1-B831826424A8@embeddedalley.com> <20090413165404.b6660aea.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <A513BF7B-5FD4-43CF-85CA-940F7102EF31@embeddedalley.com>
Cc: linux-kernel@vger.kernel.org, menage@google.com,
       containers@lists.linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Date: Mon, 13 Apr 2009 17:52:44 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 13, 2009, at 4:54 PM, Andrew Morton wrote:

> I agree.  But it would be a mighty mess if we were to turn around in
> two years time and add a second centi-percent interface.

OK, I'll do it.  I'm just going to create a couple of simple functions
within this file to serve my requirements for the string conversion.

Thanks.

	-- Dan

