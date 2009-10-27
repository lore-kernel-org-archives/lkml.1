Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZJ0TjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZJ0TjF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 15:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZJ0TjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 15:39:03 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35354 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbZJ0TjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 15:39:00 -0400
Date: Tue, 27 Oct 2009 19:38:49 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] icst525: Add missing increment
Message-ID: <20091027193849.GC22412@n2100.arm.linux.org.uk>
References: <4AE61590.2030603@gmail.com> <4AE618BB.4060601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE618BB.4060601@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:46:35PM +0100, Roel Kluin wrote:
> Without this increment the loop can only break if it does in the
> first iteration.

Ok.
