Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbYFDBFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbYFDBFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 21:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYFDBFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 21:05:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52005 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbYFDBFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 21:05:42 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080603200349.3b1957e1@vader.jdub.homelinux.org>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <4845DB46.3020308@am.sony.com>
	 <1212538597.4042.29.camel@shinybook.infradead.org>
	 <20080603200349.3b1957e1@vader.jdub.homelinux.org>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 02:05:40 +0100
Message-Id: <1212541541.4042.41.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 20:03 -0500, Josh Boyer wrote:
> On Wed, 04 Jun 2008 01:16:37 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Tue, 2008-06-03 at 17:01 -0700, Tim Bird wrote:
> > > This is clearly an improvement. But it is missing this part of the
> > > original patch:
> > 
> > Oops, well spotted. I've updated the patch in the git tree; thanks.
> 
> What git tree?

 git.infradead.org/embedded-2.6.git

-- 
dwmw2

