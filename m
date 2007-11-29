Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbXK2RsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbXK2RsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:48:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbXK2RsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:48:07 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:42360 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbXK2RsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:48:05 -0500
Subject: Re: [Patch](Resend) mm/sparse.c: Improve the error handling for
	sparse_add_one_section()
From: Dave Hansen <haveblue@us.ibm.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@osdl.org>, linux-mm@kvack.org,
       Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20071128124420.GJ2464@hacking>
References: <1195507022.27759.146.camel@localhost>
	 <20071123055150.GA2488@hacking> <20071126191316.99CF.Y-GOTO@jp.fujitsu.com>
	 <20071127022609.GA4164@hacking> <1196189625.5764.36.camel@localhost>
	 <20071128124420.GJ2464@hacking>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 09:47:30 -0800
Message-Id: <1196358450.18851.72.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine now.

Acked-by: Dave Hansen <haveblue@us.ibm.com> 

-- Dave

