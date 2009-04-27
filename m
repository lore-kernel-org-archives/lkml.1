Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZD0HWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZD0HWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZD0HWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:22:08 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44372 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbZD0HWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:22:07 -0400
Subject: Re: [patch] slqb: enforce MAX_ORDER
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0904261255520.18988@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904261255520.18988@chino.kir.corp.google.com>
Date: Mon, 27 Apr 2009 10:22:03 +0300
Message-Id: <1240816924.32709.39.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-26 at 12:56 -0700, David Rientjes wrote:
> Slabs may not be allocated at MAX_ORDER or higher.
> 
> Cc: Nick Piggin <npiggin@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks!

