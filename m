Return-Path: <linux-kernel-owner+w=401wt.eu-S1753059AbYJaTGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbYJaTGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 15:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaTGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 15:06:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59947 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYJaTGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 15:06:11 -0400
Date: Fri, 31 Oct 2008 19:06:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: alpha: undefined reference to `save_stack_trace'
Message-ID: <20081031190608.GU28946@ZenIV.linux.org.uk>
References: <20081031165751.GA13558@x200.localdomain> <20081031182411.GR28946@ZenIV.linux.org.uk> <20081031184822.GS28946@ZenIV.linux.org.uk> <20081031185526.GT28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081031185526.GT28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 06:55:26PM +0000, Al Viro wrote:

> It's too ugly for words, but it does deal with this mess ;-/

... doesn't.  Unfortunately.
