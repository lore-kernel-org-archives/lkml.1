Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbYGAG4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbYGAG4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 02:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYGAG4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 02:56:32 -0400
Received: from saeurebad.de ([85.214.36.134]:50815 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbYGAG4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 02:56:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 00/20] mm: generic show_mem() v4
References: <20080627115349.743368154@saeurebad.de>
Date: Tue, 01 Jul 2008 08:55:27 +0200
In-Reply-To: <20080627115349.743368154@saeurebad.de> (Johannes Weiner's
	message of "Fri, 27 Jun 2008 13:53:49 +0200")
Message-ID: <8763rq6qlc.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Johannes Weiner <hannes@saeurebad.de> writes:

> Every arch implements its own show_mem() function.  Most of them share
> quite some code, some of them are completely identical.
>
> This series implements a generic version of this function and migrates
> almost all architectures to it.
>
> version 4:
> 	- rebased against -mmotm

Oh, btw, do you even want them, Andrew?  Or should I base this set on
Linus' tree directly?

	Hannes
