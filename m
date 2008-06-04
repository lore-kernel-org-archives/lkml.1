Return-Path: <linux-kernel-owner+w=401wt.eu-S1760465AbYFDO2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465AbYFDO2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbYFDO2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:28:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41936 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbYFDO2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:28:11 -0400
Subject: Re: [PATCH] console - Add configurable support for console charset
	translation
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604150747.3ec7ee57@core>
References: <48447615.5050806@am.sony.com>
	 <1212500751.16924.322.camel@pmac.infradead.org>
	 <4845DB46.3020308@am.sony.com> <20080604125500.0fce2ea4@core>
	 <1212587753.32207.86.camel@pmac.infradead.org>
	 <20080604150747.3ec7ee57@core>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 15:27:53 +0100
Message-Id: <1212589673.32207.93.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 15:07 +0100, Alan Cox wrote:
> > If I merge this incremental patch, does that address your objections?
> 
> Yes

http://git.infradead.org/embedded-2.6.git?a=commitdiff;h=a29ccf6f8


-- 
dwmw2

