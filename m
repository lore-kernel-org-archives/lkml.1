Return-Path: <linux-kernel-owner+w=401wt.eu-S936945AbYEBWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936945AbYEBWh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932369AbYEBWhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:37:16 -0400
Received: from lazybastard.de ([212.112.238.170]:60394 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbYEBWhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:37:14 -0400
Date: Sat, 3 May 2008 00:37:03 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] fix checkstack.pl arch detection
Message-ID: <20080502223702.GI24080@logfs.org>
References: <481B4D75.9060305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <481B4D75.9060305@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 12:20:53 -0500, Eric Sandeen wrote:
> 
> uname -m was leaving a newline in $arch, and not passing the tests.
> 
> Also, printing the unknown arch on failure is probably helpful.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-By: Joern Engel <joern@logfs.org>

Jörn

-- 
Premature optimization is the root of all evil.
-- Donald Knuth
