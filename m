Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbZEZX0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbZEZX0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbZEZX0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:26:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758741AbZEZX0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:26:31 -0400
Date: Tue, 26 May 2009 16:25:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, adobriyan@gmail.com
Subject: Re: [PATCH 16/38] x86: ptrace debugreg checks rewrite
Message-Id: <20090526162523.f8ae061c.akpm@linux-foundation.org>
In-Reply-To: <1242968132-1044-16-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	<1242968132-1044-16-git-send-email-adobriyan@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 08:55:10 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> This is a mess.

heh.  I'm going to treat it as Ingo's mess :)
