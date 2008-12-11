Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYLKWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYLKWZj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbYLKWZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:25:29 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57720 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439AbYLKWZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:25:29 -0500
Date: Thu, 11 Dec 2008 23:26:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adam Jackson <ajax@redhat.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] net: Remove a noisy printk
Message-ID: <20081211222657.GA27757@uranus.ravnborg.org>
References: <1229033625-30825-1-git-send-email-ajax@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229033625-30825-1-git-send-email-ajax@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 05:13:42PM -0500, Adam Jackson wrote:
> From: Dave Jones <davej@redhat.com>
> 
> These messages are trivial to trigger when running stress tests
> like isic, and add no real value.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Adam Jackson <ajax@redhat.com>

I would suggest to send this to netdev.

	Sam
