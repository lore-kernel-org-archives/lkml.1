Return-Path: <linux-kernel-owner+w=401wt.eu-S1764496AbYB0CbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764496AbYB0CbE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:31:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYB0Cay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:30:54 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39507 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751690AbYB0Cax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:30:53 -0500
Date: Tue, 26 Feb 2008 20:30:50 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, Lee.Schermerhorn@hp.com, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
Message-Id: <20080226203050.ea692d8f.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014410.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250016120.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802261704310.25919@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice presentation ... thanks.

I agree with your patch to fix the MPOL_PREFERRED | MPOL_F_RELATIVE_NODES case.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
