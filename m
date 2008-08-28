Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYH1QJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYH1QJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbYH1QJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:09:34 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62895 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752670AbYH1QJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:09:33 -0400
Date: Thu, 28 Aug 2008 17:09:04 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: PATCH: Remove 8254 timer texts from Documentation
In-Reply-To: <20080828110007.69674b06@doriath.conectiva>
Message-ID: <Pine.LNX.4.55.0808281706420.15273@cliff.in.clinika.pl>
References: <20080828110007.69674b06@doriath.conectiva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Luiz Fernando N. Capitulino wrote:

> Commit ecd29476ae0143b1c3641edfa76c0fc3e9ad3021 removed the
> "disable_8254_timer" and "enable_8254_timer" kernel parameters from
> the kernel but did not remove the references to them from two
> files in the Documentation directory: kernel-parameters.txt and
> x86/x86_64/boot-options.txt.
> 
> This change completes the removal.

Acked-by: Maciej W. Rozycki <macro@linux-mips.org>

 Thanks for spotting this -- I didn't expect these were actually
documented. ;)

  Maciej
