Return-Path: <linux-kernel-owner+w=401wt.eu-S936908AbXFGVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936908AbXFGVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbXFGVcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:32:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763288AbXFGVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:32:03 -0400
Date: Thu, 7 Jun 2007 14:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 8/36] drivers edac chaange to mutex operation
Message-Id: <20070607143124.06067089.akpm@linux-foundation.org>
In-Reply-To: <27653.85350.qm@web50103.mail.re2.yahoo.com>
References: <27653.85350.qm@web50103.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:40:16 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> -static DECLARE_MUTEX(mem_ctls_mutex);
> +static DEFINE_MUTEX(mem_ctls_mutex);

doh. OK.
