Return-Path: <linux-kernel-owner+w=401wt.eu-S1030491AbXCHJqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030491AbXCHJqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030499AbXCHJqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:46:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53755 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491AbXCHJqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:46:40 -0500
Subject: Re: [PATCH] dilnetpc: Fix warning
From: David Woodhouse <dwmw2@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070307163601.3662aec1@lxorguk.ukuu.org.uk>
References: <20070307163601.3662aec1@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 09:46:37 +0000
Message-Id: <1173347197.3461.393.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 16:36 +0000, Alan Cox wrote:
> The type of a resource could be 32 or 64bit depending upon platform or
> option so cast it explicitly.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Applied; thanks.

-- 
dwmw2

