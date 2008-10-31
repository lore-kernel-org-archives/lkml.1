Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYJaIxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYJaIxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYJaIxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:53:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50168 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYJaIxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:53:41 -0400
Subject: Re: [PATCH] slub - fix get_object_page comment
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810301039080.20953@quilx.com>
References: <20081028190226.GE7357@localhost>
	 <Pine.LNX.4.64.0810301039080.20953@quilx.com>
Date: Fri, 31 Oct 2008 10:54:24 +0200
Message-Id: <1225443264.19537.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 10:39 -0500, Christoph Lameter wrote:
> On Tue, 28 Oct 2008, Cyrill Gorcunov wrote:
> 
> > Use 'slab page' instead of 'slab object'.
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>

Applied, thanks!

