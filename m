Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbYCDPur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbYCDPur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755716AbYCDPuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:50:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:34104 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbYCDPui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:50:38 -0500
Date: Tue, 4 Mar 2008 18:54:31 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] document de_thread() with exit_notify() connection
Message-ID: <20080304155431.GD564@tv-sign.ru>
References: <20080303041755.GA18920@tv-sign.ru> <20080304083847.BD60627010A@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304083847.BD60627010A@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Roland McGrath wrote:
>
> I'd still like to revisit the whole MT exec
> picture when we can.

Yes, I do remember the previous discussion, and I very much
agree with your idea how we should do this.

Oleg.

