Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbZCIUw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbZCIUw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZCIUwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:52:47 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:35350 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbZCIUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:52:46 -0400
Date: Mon, 9 Mar 2009 21:54:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
Message-ID: <20090309205441.GA19352@uranus.ravnborg.org>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James.

>  39 files changed, 550 insertions(+), 713 deletions(-)

These numbers looks god considering that you integrated Voyager
more thight with x86 using this serie.

	Sam
