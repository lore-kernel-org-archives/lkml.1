Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbZCJVak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbZCJVak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbZCJVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:30:23 -0400
Received: from ftp.linux-mips.org ([213.58.128.207]:55055 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbZCJVaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:30:20 -0400
Date: Tue, 10 Mar 2009 22:30:08 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Xiaotian Feng <Xiaotian.Feng@windriver.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1] mips: fix mips syscall wrapper sys_32_ipc bug
Message-ID: <20090310213008.GA18047@linux-mips.org>
References: <1236563112-24287-1-git-send-email-Xiaotian.Feng@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236563112-24287-1-git-send-email-Xiaotian.Feng@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 09:45:12AM +0800, Xiaotian Feng wrote:

> 
> There's a typo in mips syscall wrapper sys_32_ipc. If CONFIG_SYSVIPC
> is not set, it will cause mips linux compile error.
> 
> Signed-off-by: Xiaotian Feng <xiaotian.feng@windriver.com>

Thanks, applied.

  Ralf
