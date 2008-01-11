Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYAKAnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYAKAnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 19:43:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYAKAne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 19:43:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37315 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754701AbYAKAnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 19:43:33 -0500
Date: Thu, 10 Jan 2008 16:43:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "peerchen" <peerchen@gmail.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, acurrid@nvidia.com,
       pchen@nvidia.com
Subject: Re: [PATCH]quirks: set 'En' bit of MSI Mapping for devices on
 HT-based nvidia platform
Message-Id: <20080110164327.73524d6e.akpm@linux-foundation.org>
In-Reply-To: <200801102241563593942@gmail.com>
References: <200801102241563593942@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 22:41:58 +0800
"peerchen" <peerchen@gmail.com> wrote:

> Subject: [PATCH]quirks: set 'En' bit of MSI Mapping for devices on HT-based nvidia platform
> 
> Signed-off-by: Andy Currid <acurrid@nvidia.com>
> Signed-off-by: Peer Chen <pchen@nvidia.com>

You didn't provide a reason for making this change to the kernel.

Please do so, and include it in the patch's changelog, thanks.
