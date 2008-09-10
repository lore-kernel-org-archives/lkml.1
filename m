Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbYIJDEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbYIJDEb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 23:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYIJDEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 23:04:23 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:32201 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017AbYIJDEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 23:04:23 -0400
Date: Wed, 10 Sep 2008 12:03:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: roel kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: intc_prio_data() test before subtraction on unsigned
Message-ID: <20080910030345.GA25508@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	roel kluin <roel.kluin@gmail.com>, linux-kernel@vger.kernel.org
References: <48C6E473.9070408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C6E473.9070408@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2008 at 11:02:43PM +0200, roel kluin wrote:
> bit is unsigned, so test before subtraction
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Applied, thanks.

In the future, please make sure to CC linux-sh@vger.kernel.org on any SH
related patches.
