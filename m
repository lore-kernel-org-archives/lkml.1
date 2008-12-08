Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbYLHCeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbYLHCeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755711AbYLHCd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:33:58 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25303 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755526AbYLHCd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:33:57 -0500
Date: Mon, 8 Dec 2008 11:32:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nick Andrew <nick@nick-andrew.net>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix incorrect use of loose in c-checksum.c
Message-ID: <20081208023218.GA8860@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Nick Andrew <nick@nick-andrew.net>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20081205030757.31846.86233.stgit@marcab.local.tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205030757.31846.86233.stgit@marcab.local.tull.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 02:07:57PM +1100, Nick Andrew wrote:
> Fix incorrect use of loose in c-checksum.c
> 
> It should be 'lose', not 'loose'.
> 
> Signed-off-by: Nick Andrew <nick@nick-andrew.net>

Applied.
