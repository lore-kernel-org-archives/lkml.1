Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXLMOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXLMOeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 09:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXLMOdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 09:33:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49998 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbXLMOdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 09:33:50 -0500
Date: Thu, 13 Dec 2007 15:33:59 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Andi Kleen <andi@firstfloor.org>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: separate objdir Makefile regression in 2.6.24-rc*
Message-ID: <20071213143359.GA31269@one.firstfloor.org>
References: <20071213134841.GA25103@basil.nowhere.org> <3d8471ca0712130616w4a34b53bs2faafb159df17510@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d8471ca0712130616w4a34b53bs2faafb159df17510@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 03:16:27PM +0100, Guillaume Chazarain wrote:
> On Dec 13, 2007 2:48 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > 2.6.24-rc5 doesn't seem to create Makefiles in empty obj dirs anymore
> 
> Known problem ;-)
> See http://groups.google.com/group/fa.linux.kernel/browse_thread/thread/188cbd12d7c0871b/194fbc7c94314b2c

Ah, thanks. But it looks like that patch isn't in Linus' tree yet. Sam? 

-Andi
