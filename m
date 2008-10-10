Return-Path: <linux-kernel-owner+w=401wt.eu-S1761969AbYJJSCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761969AbYJJSCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 14:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYJJSCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 14:02:12 -0400
Received: from mail.atheros.com ([12.36.123.2]:57732 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760103AbYJJSCL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 14:02:11 -0400
Date: Fri, 10 Oct 2008 04:01:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       Jouni Malinen <Jouni.Malinen@atheros.com>
Subject: Re: [PATCH 1/1] Ath9k: fix uninitialized value in ath9k_hw_reset
Message-ID: <20081010110158.GG6766@tesla>
References: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1223661403-21803-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 10:56:43AM -0700, Jiri Slaby wrote:
> status ath9k_hw_reset() parameter should be set in every case, since
> it is used in callers to find out an error code.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Thanks!

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
