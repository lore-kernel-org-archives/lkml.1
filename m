Return-Path: <linux-kernel-owner+w=401wt.eu-S935838AbXGZQn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935838AbXGZQn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 12:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934752AbXGZQge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 12:36:34 -0400
Received: from hu-out-0506.google.com ([72.14.214.228]:15746 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763079AbXGZQgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 12:36:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rG63BJ4VKf9UPiME6gNxpMBA3LM/2ejOHplUPuHfYrIDiEwOqjvordzJIcqkr3mn3dMN9hyE5YLGvAZfPJU8wIO3NFoOoLmspxrIC2KqExgMraBreQlaefKX7gPHeJwoP+GEdcWemK7UMdZlX+kaB6+WzVkJFEi7JhBoiAxMvys=
Date: Thu, 26 Jul 2007 17:36:18 +0100
From: Xudong Guan <xudong.guan@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1: no setup signature found...
Message-ID: <20070726163618.GA13789@xguan-laptop>
References: <20070724112618.GA4431@gollum.tnic> <20070726150854.GA7034@xguan-laptop> <46A8BB6C.6050903@zytor.com> <20070726163053.GA4570@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726163053.GA4570@gollum.tnic>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:30(+0200) Thu 26 Jul, Borislav Petkov wrote:
> grub version:
> Version: 0.97-29

On my real machine with grub 0.97, there is no problem loading the
same kernel.

Xudong
