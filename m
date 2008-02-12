Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbYBLWdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbYBLWdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 17:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYBLWdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 17:33:11 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751442AbYBLWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 17:33:10 -0500
Date: Tue, 12 Feb 2008 14:32:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, tes@sgi.com
Subject: Re: [PATCH] xfs: convert beX_add to beX_add_cpu (new common API)
Message-Id: <20080212143234.3cb52dbc.akpm@linux-foundation.org>
In-Reply-To: <20080210101759.GC6737@joi>
References: <20080210101759.GC6737@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Feb 2008 11:18:09 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> This patch was in Andrew tree, but it was uncomplete.
> Here is updated version.

This is identical to what I already had.
