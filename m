Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYHYRwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYHYRwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYHYRwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:52:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:51978 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbYHYRwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:52:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gTA9TpuzTEfJawfbw2K0YkLT9Gw6FinJyKDnbEenyOf1iwCRki4JSxBQdTOH3jUxIm
         7X16LHRTnVkEtlwAkphe/zx57ra1ULF7u629/+jrSfyzam13mP6tt4kJD6eUuFTkVpyY
         OQ5i0rDq7Jmme0FJzwSLlPOYoaTjn2CBeRbvo=
Message-ID: <c62985530808251052i520d055el1c7d8d94966943fe@mail.gmail.com>
Date: Mon, 25 Aug 2008 18:52:01 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [Patch] Tracing/ftrace: Adds a marker to allow user comments
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0808251237340.23923@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B1D5CA.8000607@gmail.com> <20080825084405.GA29195@elte.hu>
	 <c62985530808250659w5b2a2f83u689987969a4cb53d@mail.gmail.com>
	 <alpine.DEB.1.10.0808251237340.23923@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/25 Steven Rostedt <rostedt@goodmis.org>:
>
> Feel free to make TRACE_CONT work for you. I coupled it a little more than
> I wanted to with the ftrace print. If you can find a nice way to make
> TRACE_CONT a bit more generic, then feel free.
>
> -- Steve
>
>

Thanks.
But TRACE_CONT is not a problem. It is generic enough to contain parts
of a TRACE_MARK message and that's why I use it in my patch.
