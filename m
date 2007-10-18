Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbXJRBHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbXJRBHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758570AbXJRBHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:07:07 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758595AbXJRBHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:07:05 -0400
Date: Wed, 17 Oct 2007 18:00:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: sds@tycho.nsa.gov, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       morgan@kernel.org, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       kaigai@kaigai.gr.jp, casey@schaufler-ca.com
Subject: Re: [RFC] [PATCH 2/2] capabilities: implement 64-bit capabilities
Message-Id: <20071017180002.33fe4986.akpm@linux-foundation.org>
In-Reply-To: <20071016214159.GB13294@sergelap.austin.ibm.com>
References: <20071016022730.GA8925@sergelap.austin.ibm.com>
	<20071016023100.GA10698@sergelap.austin.ibm.com>
	<1192544299.8702.78.camel@moss-spartans.epoch.ncsc.mil>
	<20071016214159.GB13294@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 16:41:59 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> To properly test this the libcap code will need to be updated first,
> which I'm looking at now...

This seems fairly significant.  I asusme that this patch won't break
presently-deployed libcap?
