Return-Path: <linux-kernel-owner+w=401wt.eu-S933610AbZFLJv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610AbZFLJv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbZFLJva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:51:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42543 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519AbZFLJv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:51:29 -0400
Date: Fri, 12 Jun 2009 11:59:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] HWPOISON: remove early kill option for now
Message-ID: <20090612095928.GB25568@one.firstfloor.org>
References: <20090611142239.192891591@intel.com> <20090611144430.682162784@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611144430.682162784@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 10:22:42PM +0800, Wu Fengguang wrote:
> It needs more thoughts, and is not a must have for .31.

Please don't do that. I don't think the problem Hugh described is fatal
and there are some scenarios where it is needed.


-Andi
