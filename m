Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbZDXOya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbZDXOya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZDXOyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:54:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57920 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbZDXOyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:54:20 -0400
Date: Fri, 24 Apr 2009 10:53:42 -0400
From: Dave Jones <davej@redhat.com>
To: Luis Henriques <henrix@sapo.pt>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Devriendt <paul.devriendt@amd.com>,
       Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] powernow-k8.c: mess cleanup
Message-ID: <20090424145342.GC18310@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Luis Henriques <henrix@sapo.pt>, Ingo Molnar <mingo@elte.hu>,
	Paul Devriendt <paul.devriendt@amd.com>,
	Mark Langsdorf <mark.langsdorf@amd.com>,
	linux-kernel@vger.kernel.org
References: <20090423184504.GA5487@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423184504.GA5487@hades.domain.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 07:45:04PM +0100, Luis Henriques wrote:
 > Mess cleanup in powernow_k8_acpi_pst_values() function.
 > 
 > Signed-off-by: Luis Henriques <henrix@sapo.pt>
 
Introduced by me in 0e64a0c982c06a6b8f5e2a7f29eb108fdf257b2f

I have no idea wtf I did there, nor how I missed it
before submitting.

	Dave
