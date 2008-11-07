Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYKGXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYKGXUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 18:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYKGXUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 18:20:42 -0500
Received: from mail.cyberdogtech.com ([64.22.125.39]:40441 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbYKGXUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 18:20:41 -0500
Date: Fri, 7 Nov 2008 17:20:33 -0600
From: Matt LaPlante <kernel@cyberdogtech.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [PATCH] Change default for STRICT_DEVMEM
Message-Id: <20081107172033.a8df8eed.kernel@cyberdogtech.com>
In-Reply-To: <20081107220038.50345845@lxorguk.ukuu.org.uk>
References: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
	<20081107220038.50345845@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 22:00:38 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri,  7 Nov 2008 14:18:36 -0600
> Matt LaPlante <kernel1@cyberdogtech.com> wrote:
> 
> > The recommendation for STRICT_DEVMEM is to select Y,
> > however the option currently defaults to N.  Have the option
> > default to Y since it is recommended.
> 
> The recommendation is extremely dubious as it breaks a lot of back
> compatibility.
> 
Revert the default and toggle the recommendation then?

-- 
Matt LaPlante <kernel@cyberdogtech.com>
