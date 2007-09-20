Return-Path: <linux-kernel-owner+w=401wt.eu-S1753833AbXITXLP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbXITXLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 19:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbXITXLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 19:11:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55365 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbXITXLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 19:11:00 -0400
Date: Thu, 20 Sep 2007 16:10:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/11] Text Edit Lock for 2.6.23-rc6-mm1
Message-Id: <20070920161018.0b4e7ec3.akpm@linux-foundation.org>
In-Reply-To: <20070918210601.028313546@polymtl.ca>
References: <20070918210601.028313546@polymtl.ca>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:06:01 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Here are the text edit lock patches ported to 2.6.23-rc6-mm1.

I think I'll duck these one more time.  There was a bit of followup
and for now I'd prefer to concentrate on obviously-safe stuff and
stabilisation of the current 2.6.24 queue.
