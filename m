Return-Path: <linux-kernel-owner+w=401wt.eu-S1758396AbXJLNKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758396AbXJLNKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 09:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbXJLNKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 09:10:11 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:54998 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXJLNKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 09:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qEAwtRaREdmpVVbjIxybeKcj15KBbVJZ96eUTSyFEBraCymFO1KB97mNHlovxdzheEsZ6WnqHZZhqZSfmCixve9kfTmBwKY5N+G6sM1HwJqLGsM6FlLWaGwl139Hg0obJOuWIpP8wRoT/x53wQijknOBN2uHPHp73Yijq/eX/2U=
Message-ID: <da3e877f0710120610v5306b8f6t8ddae1bb56ba5db7@mail.gmail.com>
Date: Fri, 12 Oct 2007 13:10:07 +0000
From: "Mauro Giachero" <mauro.giachero@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Don't needlessly dirty mlocked pages when initially faulting them in.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Suleiman Souhlal" <ssouhlal@freebsd.org>, linux-kernel@vger.kernel.org,
       "Suleiman Souhlal" <suleiman@google.com>
In-Reply-To: <1185518010.15205.36.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11854939641916-git-send-email-ssouhlal@FreeBSD.org>
	 <20070726172330.d3409b57.akpm@linux-foundation.org>
	 <1185518010.15205.36.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/27/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> [...]
> +        * We want to touch writable mappings with a write fault in otder
> [...]

otder -> order

Greetings
Mauro
