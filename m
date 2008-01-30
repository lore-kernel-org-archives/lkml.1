Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbYA3OVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbYA3OVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 09:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761848AbYA3OVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 09:21:31 -0500
Received: from gate.crashing.org ([63.228.1.57]:46782 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872AbYA3OV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 09:21:29 -0500
Cc: mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Message-Id: <AF5092BE-3384-44F8-A104-560DD4331726@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Zhang Wei <wei.zhang@freescale.com>
In-Reply-To: <120168907160-git-send-email-wei.zhang@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: [PATCH 3/6] Move include/asm-ppc/rio.h to include/asm-powerpc/rio.h
Date: Wed, 30 Jan 2008 08:20:48 -0600
References: <1201689053956-git-send-email-wei.zhang@freescale.com> <12016890621727-git-send-email-wei.zhang@freescale.com> <120168907160-git-send-email-wei.zhang@freescale.com>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30, 2008, at 4:30 AM, Zhang Wei wrote:

> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> ---
> include/asm-powerpc/rio.h |   18 ++++++++++++++++++
> include/asm-ppc/rio.h     |   18 ------------------
> 2 files changed, 18 insertions(+), 18 deletions(-)
> create mode 100644 include/asm-powerpc/rio.h
> delete mode 100644 include/asm-ppc/rio.h

it seems with OF we can just git rid of this?

-k

