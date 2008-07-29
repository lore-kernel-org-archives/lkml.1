Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYG2Ikp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYG2Ikp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 04:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYG2Ikh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 04:40:37 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:47482 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753573AbYG2Ikg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 04:40:36 -0400
Date: Tue, 29 Jul 2008 17:39:56 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>
Cc: linux-sh@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Fix compile error of Solution Engine
Message-ID: <20080729083956.GC29389@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>,
	linux-sh@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
	linux-kernel@vger.kernel.org
References: <488EAC95.4060507@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488EAC95.4060507@renesas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 02:37:25PM +0900, Nobuhiro Iwamatsu wrote:
> When I compiled Solution Engine, this become compile error
> because plaform device of sh_eth device becomes enable.
> When sh7710/sh7712 which could use sh_eth was chosen,
> revised it so that platform device of sh_eth device became enable.
> 
> Signed-off-by: Nobuhiro Iwamatsu <iwamatsu.nobuhiro@renesas.com>

Applied, thanks.
