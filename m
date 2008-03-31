Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbYCaD6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbYCaD6S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 23:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYCaD6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 23:58:06 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:4725 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753470AbYCaD6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 23:58:04 -0400
Date: Mon, 31 Mar 2008 12:57:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] sh: remove the broken SH_MPC1211 support
Message-ID: <20080331035752.GB7744@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080330224017.GE28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080330224017.GE28445@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 01:40:17AM +0300, Adrian Bunk wrote:
> SH_MPC1211 has been marked as BROKEN for some time.
> 
> Unless someone is working on reviving it now, I'd therefore suggest this 
> patch to remove it.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Indeed, I'll add this to the 2.6.26 queue, thanks.
