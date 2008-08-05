Return-Path: <linux-kernel-owner+w=401wt.eu-S1762214AbYHEAfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762214AbYHEAfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbYHEAfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:35:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55240 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbYHEAfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:35:38 -0400
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
	interface	for on access scanning
From: Eric Paris <eparis@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
In-Reply-To: <1217896374.27684.53.camel@localhost.localdomain>
References: <1217883616.27684.19.camel@localhost.localdomain>
	 <20080804223249.GA10517@kroah.com>
	 <1217896374.27684.53.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 20:35:34 -0400
Message-Id: <1217896534.27684.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 20:32 -0400, Eric Paris wrote:

> The model only makes claims about open and I want to be forthright with
> its shortcomings.  It sounds rather unreasonable to think that every
> time I want to read one bite from a file which is being concurrently
> written by another process some virus scanner should have to reread and
> validate the entire file.  I think as some point we have to accept the


Sorry, can't help but laugh at myself for typing "bite".

-Eric

