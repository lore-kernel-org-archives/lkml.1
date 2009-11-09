Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZKIIRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZKIIRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbZKIIRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:17:41 -0500
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:38964 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbZKIIRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:17:41 -0500
Message-ID: <4AF7D028.6050008@ladisch.de>
Date: Mon, 09 Nov 2009 09:17:44 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/23] sysctl drivers: Remove dead binary sysctl support
References: <m14op5jjo4.fsf@fess.ebiederm.org> <1257682930-31401-14-git-send-email-ebiederm@xmission.com>
In-Reply-To: <1257682930-31401-14-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Now that sys_sysctl is a wrapper around /proc/sys all of
> the binary sysctl support elsewhere in the tree is
> dead code.
> 
> Cc: Clemens Ladisch <clemens@ladisch.de>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
for this:
>  drivers/char/hpet.c               |    9 ++-----
