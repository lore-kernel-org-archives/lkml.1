Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbYEVLTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbYEVLTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 07:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753734AbYEVLTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 07:19:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbYEVLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 07:19:05 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Luming Yu" <luming.yu@gmail.com>
Cc: "Petr Tesarik" <ptesarik@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-ia64@vger.kernel.org
Subject: Re: [RFC PATCH] set TASK_TRACED before arch_ptrace code to fix a race
In-Reply-To: Luming Yu's message of  Thursday, 22 May 2008 17:16:28 +0800 <3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
References: <3877989d0805211947i54bacc7cv619541e9b40824fb@mail.gmail.com>
	<1211446045.5610.33.camel@elijah.suse.cz>
	<3877989d0805220216o5add20ddye2a1fde98a0c1e69@mail.gmail.com>
X-Shopping-List: (1) Academic inquisitive samples
   (2) Enigmatic puppy prostitutes
   (3) Cancerous illusion putty
Message-Id: <20080522111826.BB90326FA24@magilla.localdomain>
Date: Thu, 22 May 2008 04:18:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I really cannot figure out from anything you've said what the failure mode
is or how you think it should be affected.


Thanks,
Roland
