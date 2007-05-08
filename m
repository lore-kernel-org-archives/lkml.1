Return-Path: <linux-kernel-owner+w=401wt.eu-S1032003AbXEHUGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032003AbXEHUGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 16:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031988AbXEHUGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 16:06:33 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031982AbXEHUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 16:06:30 -0400
Date: Tue, 8 May 2007 13:05:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       jeffschroeder@computer.org, Chris Wright <chrisw@sous-sol.org>,
       Karl MacMillan <kmacmillan@mentalrootkit.com>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH 0/2] file capabilities: Introduction
Message-Id: <20070508130517.ecef3dcb.akpm@linux-foundation.org>
In-Reply-To: <20070508191548.GA29913@sergelap.austin.ibm.com>
References: <20070508191548.GA29913@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 14:15:48 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Following are two patches which have been sitting for some time in -mm.

Where "some time" == "nearly six months".

We need help considering, reviewing and testing this code, please.
