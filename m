Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYCPKLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYCPKLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 06:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYCPKLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 06:11:32 -0400
Received: from saeurebad.de ([85.214.36.134]:37663 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbYCPKLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 06:11:31 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Artem S. Tashkinov" <birdie@permonline.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GIT commit description flag(s)
References: <47DC4104.1070109@permonline.ru>
Date: Sun, 16 Mar 2008 11:09:37 +0100
In-Reply-To: <47DC4104.1070109@permonline.ru> (Artem S. Tashkinov's message of
	"Sun, 16 Mar 2008 02:35:00 +0500")
Message-ID: <87zlsz0yla.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Artem S. Tashkinov" <birdie@permonline.ru> writes:

> It would be nice if [kernel] git commits had a flag [a char] (or a
> combination of) describing their main purpose which could be the
> following:
>
> bug Fix [F]
> Speed up/Performance [S]
> Revert [R]
> New functionality [N]

> This way it will be much easier to keep track of important changes
> happening to the kernel.

You claim there are unimportant ones? :)

	Hannes
