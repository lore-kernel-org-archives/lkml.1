Return-Path: <linux-kernel-owner+w=401wt.eu-S1759640AbXLLLY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759640AbXLLLY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXLLLYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:24:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35498 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750856AbXLLLYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:24:50 -0500
Date: Wed, 12 Dec 2007 03:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/47] Minor updates to CRISv32 kernel/process.c
Message-Id: <20071212032446.574a7db6.akpm@linux-foundation.org>
In-Reply-To: <b7459b0dc261cc213217c3f321167ea226292d94.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
	<b7459b0dc261cc213217c3f321167ea226292d94.1196848533.git.jesper.nilsson@axis.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 10:54:15 +0100 Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> -	/* Parameter to ret_from_sys_call. 0 is don't restart the syscall. */
> +	/* Paramater to ret_from_sys_call. 0 is don't restart the syscall. */

"Parameter".
