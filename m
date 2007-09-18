Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXIRIYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXIRIYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:24:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXIRIY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:24:28 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33579 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbXIRIY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:24:27 -0400
Date: Tue, 18 Sep 2007 01:24:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1
Message-Id: <20070918012424.07f74aee.akpm@linux-foundation.org>
In-Reply-To: <20070918011841.2381bd93.akpm@linux-foundation.org>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 01:18:41 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> - And it hangs during suspend-to-RAM, due to git-acpi.patch

Make that "suspend-to-disk".
