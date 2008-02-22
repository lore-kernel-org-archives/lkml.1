Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbYBVMoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbYBVMoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 07:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbYBVMoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 07:44:04 -0500
Received: from ag-out-0708.google.com ([72.14.246.243]:33624 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbYBVMoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 07:44:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=sXo84Fy5gAw7h0RwbwYcO2pS2BB6sa6LD2bmxEdLFb0IyqM4Iz/Xd8caGqhSyPkVRChgfmk/VrZvQvD9NRSy6oVl1F2v2qeKeyYYZXRuikDR/2QWjRdtPxnOXhaU+erUj0HACfoe4NGaU+RyXeMP17QPUJoyurCMVp0hnX2rxLU=
Date: Fri, 22 Feb 2008 20:39:00 +0800 (CST)
Message-Id: <20080222.203900.43426213.xiyou.wangcong@gmail.com>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 09/16] um: use get_personality()
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080220162734.GC8828@c2.user-mode-linux.org>
References: <12035064241213-git-send-email-xiyou.wangcong@gmail.com>
	<12035064291055-git-send-email-xiyou.wangcong@gmail.com>
	<20080220162734.GC8828@c2.user-mode-linux.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 09/16] um: use get_personality()
Date: Wed, 20 Feb 2008 11:27:34 -0500
Message-ID: <20080220162734.GC8828@c2.user-mode-linux.org>

> On Wed, Feb 20, 2008 at 07:19:13PM +0800, WANG Cong wrote:
> > Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> 
> Looks good - you should add some sort of changelog though.
> 

Thanks, Jeff.

It seems that you're the only one who received this patchset of mine.
And I found that lkml.org didn't receive these neither. ;(

I don't know if Andrew received all of them, if not, I must resend.

Regards.
