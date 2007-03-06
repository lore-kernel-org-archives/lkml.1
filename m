Return-Path: <linux-kernel-owner+w=401wt.eu-S1030396AbXCFWZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030396AbXCFWZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030391AbXCFWZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:25:12 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030396AbXCFWZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:25:10 -0500
Date: Tue, 6 Mar 2007 14:25:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch 1/8] fix race in clear_page_dirty_for_io()
Message-Id: <20070306142507.a9f9b4c4.akpm@linux-foundation.org>
In-Reply-To: <20070306180548.179598369@szeredi.hu>
References: <20070306180443.669036741@szeredi.hu>
	<20070306180548.179598369@szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Mar 2007 19:04:44 +0100
Miklos Szeredi <miklos@szeredi.hu> wrote:

> Fix race in clear_page_dirty_for_io() as suggested by Linus.

please describe this race.
