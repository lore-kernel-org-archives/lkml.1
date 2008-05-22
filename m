Return-Path: <linux-kernel-owner+w=401wt.eu-S934441AbYEVINH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbYEVINH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbYEVIMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:12:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46343 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761768AbYEVIMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:12:45 -0400
Date: Thu, 22 May 2008 01:10:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH -mm] remove node_ prefix_from ns subsystem
Message-Id: <20080522011053.680f7f65.akpm@linux-foundation.org>
In-Reply-To: <48352277.4010703@fr.ibm.com>
References: <48344409.9090903@fr.ibm.com>
	<20080521220657.12e8e8c9.akpm@linux-foundation.org>
	<6599ad830805220011u77313ed7s2c0c9d4a658133cc@mail.gmail.com>
	<20080522003213.d677ba30.akpm@linux-foundation.org>
	<48352277.4010703@fr.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008 09:36:23 +0200 Cedric Le Goater <clg@fr.ibm.com> wrote:

> > What is the reason for making this change?
> 
> the 'node_' prefix really is superfluous and misleading. what's a node ?

For gawd's sake guys.  I've asked three times and now I'm getting
rhetorical questions for answers.  It's like drawing teeth.

Will someone please write a halfway decent description of this change? 
One which (at least) covers all the questions I've been asking?

What the change is, why it is being made, what the user-visible
presentation is, what the impact upon users is, why we think it won't
be a problem, etc?  The stuff which should have been right there from
day one, before the code change was even made?

Thanks.
