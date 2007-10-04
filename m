Return-Path: <linux-kernel-owner+w=401wt.eu-S1762770AbXJDXtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762770AbXJDXtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760250AbXJDXti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:49:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbXJDXth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:49:37 -0400
Message-ID: <47057C10.5030603@redhat.com>
Date: Thu, 04 Oct 2007 19:49:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: SLUB performance regression vs SLAB
References: <MDEHLPKNGKAHNMBLJOLKMEFNHEAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKMEFNHEAC.davids@webmaster.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2007 07:39 PM, David Schwartz wrote:
> But this is just a preposterous position to put him in. If there's no
> reproduceable test case, then why should he care that one program he can't
> even see works badly? If you care, you fix it.
> 

People have been trying for years to make reproducible test cases
for huge and complex workloads. It doesn't work. The tests that do
work take weeks to run and need to be carefully validated before
they can be officially released. The open source community can and
should be working on similar tests, but they will never be simple.
