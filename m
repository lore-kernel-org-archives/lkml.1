Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZKJUjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZKJUjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 15:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758057AbZKJUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 15:39:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758032AbZKJUjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 15:39:15 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH v2] ptrace: copy_process() should disable stepping
In-Reply-To: Oleg Nesterov's message of  Tuesday, 10 November 2009 00:53:14 +0100 <20091109235314.GA32084@redhat.com>
References: <20091106211637.GA1696@redhat.com>
	<20091106212554.BD731CF@magilla.sf.frob.com>
	<20091106215004.GA2232@redhat.com>
	<20091106221002.8057DCF@magilla.sf.frob.com>
	<20091107215547.GA25335@redhat.com>
	<20091109041546.925461E@magilla.sf.frob.com>
	<20091109235314.GA32084@redhat.com>
X-Zippy-Says: I decided to be JOHN TRAVOLTA instead!!
Message-Id: <20091110203914.4D15F8C0@magilla.sf.frob.com>
Date: Tue, 10 Nov 2009 12:39:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Roland McGrath <roland@redhat.com>
