Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891AbYJ1N7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbYJ1N7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 09:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752778AbYJ1N66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 09:58:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:42078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbYJ1N66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 09:58:58 -0400
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Message-Id: <FF9EE100-B6AD-40DC-8F88-8F1C4245D8CE@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
In-Reply-To: <20081013040703.GA11059@ime.usp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] powerpc: compile kernel for linkstations optimized for size
Date: Tue, 28 Oct 2008 08:58:42 -0500
References: <20081013040703.GA11059@ime.usp.br>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 12, 2008, at 11:07 PM, Rogério Brito wrote:

> From: Rogério Brito <rbrito@ime.usp.br>
>
> Since Linkstations and Kuroboxes often have *very* little memory (as
> they are embedded systems), it is desirable to get their kernels
> compiled optimized for size.
>
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
>
> ---

applied to merge.

- k