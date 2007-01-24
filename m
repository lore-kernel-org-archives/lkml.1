Return-Path: <linux-kernel-owner+w=401wt.eu-S965475AbXAXAxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965475AbXAXAxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:53:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965606AbXAXAxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:53:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45360 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965475AbXAXAxh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:53:37 -0500
Date: Tue, 23 Jan 2007 16:53:33 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, jaharkes@cs.cmu.edu
Subject: Re: [PATCH] seq_file conversion: coda
Message-Id: <20070123165333.7c237a0e.akpm@osdl.org>
In-Reply-To: <20070115215305.GC5010@martell.zuzino.mipt.ru>
References: <20070115215305.GC5010@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jan 2007 00:53:05 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Compile-tested.

You can runtime-test this interface without ever having mounted a CODA fs.

Please.   compile-tested-only patches are always a worry.

