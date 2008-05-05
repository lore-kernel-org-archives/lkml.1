Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYEEUct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYEEUct (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760975AbYEEUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:32:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760941AbYEEUcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:32:24 -0400
Date: Mon, 5 May 2008 13:31:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: sfr@canb.auug.org.au, torvalds@linux-foundation.org, dwmw2@infradead.org,
       arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: LogFS merge
Message-Id: <20080505133132.7d502dab.akpm@linux-foundation.org>
In-Reply-To: <20080502133234.GA24080@logfs.org>
References: <20080502133234.GA24080@logfs.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2008 15:32:34 +0200
J__rn Engel <joern@logfs.org> wrote:

> master.kernel.org:/pub/scm/linux/kernel/git/joern/logfs.git/

I added this to the -mm pile.

Thank you for not putting your Makefile and Kconfig changes right at the
end of the file like everyone else always does.  It actually merges.

