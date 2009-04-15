Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZDOXnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZDOXnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZDOXna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:43:30 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:38786 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZDOXna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:43:30 -0400
Date: Thu, 16 Apr 2009 09:43:28 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Jerry Wang <jerry18th@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel Cross-Compiling question
Message-ID: <20090415234328.GX16602@bilbo.ozlabs.org>
Mail-Followup-To: Jerry Wang <jerry18th@yahoo.com>,
	linux-kernel@vger.kernel.org
References: <344183.64836.qm@web65503.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <344183.64836.qm@web65503.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 07:18:13AM -0700, Jerry Wang wrote:
> 
> Hi,
> 
> I am trying to cross-compile the linux 2.6.11.1 kernel on
> i686 vm for ppc, and I've been getting the following
> errors. Has anyone had this issue before?

Can you post the command you used to genberate the .config and build the
kernel.  Also what is version of your powerpc binutils and gcc?

I assume you need 2.6.11.1 for some reason and newer kernels are out of the
question?

Yours Tony
