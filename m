Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0CDQqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:46:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:45843 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460Ab0CDQqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:46:23 -0500
Subject: Re: [PATCH 44/66] arch/powerpc/sysdev/cpm2_pic.h: Checkpatch cleanup
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1267289508-31031-45-git-send-email-andrea.gelmini@gelma.net>
Date: Thu, 4 Mar 2010 10:45:13 -0600
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@ozlabs.org
Content-Transfer-Encoding: 7bit
Message-Id: <05F3112F-EE86-4682-B89D-E6E6C5EB8FC8@kernel.crashing.org>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net> <1267289508-31031-45-git-send-email-andrea.gelmini@gelma.net>
To: Andrea Gelmini <andrea.gelmini@gelma.net>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 27, 2010, at 10:51 AM, Andrea Gelmini wrote:

> arch/powerpc/sysdev/cpm2_pic.h:6: ERROR: "(foo*)" should be "(foo *)"
> 
> Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
> ---
> arch/powerpc/sysdev/cpm2_pic.h |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)

applied to next

- k
