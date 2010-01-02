Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420Ab0ABCnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab0ABCnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 21:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398Ab0ABCnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 21:43:22 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63169 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0ABCnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 21:43:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W0ZCvOt6L3NYyeelIl3NHINDoZfoRLpzh/ayBrjRvTLhvE1AF+upuFKC5qVOasBKQW
         FxwGztZh4bKw0ZJf6lcG4fCTNovVwq/sW9yETNXiQY7z6uxAeJI1a/omOy93sgryDNho
         4nVUBLc5EMQD7RRWOBMhc1Zt9yUXEMakAxyhw=
Date: Fri, 1 Jan 2010 18:43:16 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] input: keyboard: twl4030: move to
 request_threaded_irq
Message-ID: <20100102024316.GB5788@core.coreip.homeip.net>
References: <1261998172-29760-1-git-send-email-felipe.balbi@nokia.com>
 <1261998172-29760-3-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261998172-29760-3-git-send-email-felipe.balbi@nokia.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 01:02:50PM +0200, Felipe Balbi wrote:
> move to request_threaded_irq() on twl4030 children.
> 

Applied both keyboard and powerbutton patches, thanks Felipe.

-- 
Dmitry
