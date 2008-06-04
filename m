Return-Path: <linux-kernel-owner+w=401wt.eu-S1756632AbYFDAQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632AbYFDAQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYFDAQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:16:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbYFDAQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:16:39 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4845DB46.3020308@am.sony.com>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <4845DB46.3020308@am.sony.com>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 01:16:37 +0100
Message-Id: <1212538597.4042.29.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 17:01 -0700, Tim Bird wrote:
> This is clearly an improvement. But it is missing this part of the
> original patch:

Oops, well spotted. I've updated the patch in the git tree; thanks.

(that's what comes of applying patches by hand -- I _knew_ I had to do
that hunk, but managed to forget about it within the space of about 30
seconds when I was doing the other parts. I plead stupidity)

-- 
dwmw2

