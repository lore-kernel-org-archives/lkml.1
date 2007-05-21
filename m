Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXEUDg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXEUDg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 23:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355AbXEUDgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 23:36:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbXEUDgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 23:36:07 -0400
Date: Sun, 20 May 2007 20:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righiandr@users.sourceforge.net
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] log out-of-virtual-memory events (was: [RFC] log
 out-of-virtual-memory events)
Message-Id: <20070520203209.ec952a84.akpm@linux-foundation.org>
In-Reply-To: <464ED292.8020202@users.sourceforge.net>
References: <E1Hp5RZ-0001CF-00@calista.eckenfels.net>
	<464ED292.8020202@users.sourceforge.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 12:34:01 +0200 (MEST) Andrea Righi <righiandr@users.sourceforge.net> wrote:

> Print informations about userspace processes that fail to allocate new virtual
> memory.

Why is this useful?
