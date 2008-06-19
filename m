Return-Path: <linux-kernel-owner+w=401wt.eu-S1760795AbYFSMvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbYFSMvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYFSMvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:51:24 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40547 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYFSMvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:51:23 -0400
Date: Thu, 19 Jun 2008 16:51:15 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Andre Haupt <andre@bitwigglers.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: remove duplicate include of linux/interrupt.h
Message-ID: <20080619125115.GA10549@2ka.mipt.ru>
References: <1213879388-11418-1-git-send-email-andre@bitwigglers.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213879388-11418-1-git-send-email-andre@bitwigglers.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, Jun 19, 2008 at 02:43:08PM +0200, Andre Haupt (andre@bitwigglers.org) wrote:
> Signed-off-by: Andre Haupt <andre@bitwigglers.org>

Thank you for the patch,  but similar one from Huang Weiyi is in Herbert Xu
cryptodev-2.6 tree an will be pushed upstream in upcoming merge window.

-- 
	Evgeniy Polyakov
