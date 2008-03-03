Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYCCWjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYCCWjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYCCWj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:39:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756452AbYCCWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:39:28 -0500
Date: Mon, 3 Mar 2008 14:36:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com,
       systemtap@sources.redhat.com, jkenisto@us.ibm.com
Subject: Re: [PATCH][2.6.25-rc2-mm1] fix a null pointer bug in
 register_kretprobe
Message-Id: <20080303143610.3a8c2f4b.akpm@linux-foundation.org>
In-Reply-To: <47CC7B1C.1060305@redhat.com>
References: <47CC7B1C.1060305@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Mar 2008 17:26:36 -0500
Masami Hiramatsu <mhiramat@redhat.com> wrote:
>

This:

> Subject: [PATCH][2.6.25-rc2-mm1] fix a null pointer bug in register_kretprobe 

implies (to me) that the patch fixes a bug which is only in -mm.  But
afacit this is a bugfix against mainline, yes?


