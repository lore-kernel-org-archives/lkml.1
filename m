Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYEWWnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYEWWnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYEWWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:43:11 -0400
Received: from saeurebad.de ([85.214.36.134]:59497 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYEWWnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:43:10 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Kristian =?utf-8?Q?H=C3=B8gsberg?= <krh@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Only print "Decompressing Linux" etc when 'noisy' is passed.
References: <1211579968-15227-1-git-send-email-krh@redhat.com>
	<1211579968-15227-2-git-send-email-krh@redhat.com>
Date: Sat, 24 May 2008 00:42:38 +0200
In-Reply-To: <1211579968-15227-2-git-send-email-krh@redhat.com> ("Kristian
	=?utf-8?Q?H=C3=B8gsberg=22's?= message of "Fri, 23 May 2008 17:59:28
 -0400")
Message-ID: <877idkod5t.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Kristian Høgsberg <krh@redhat.com> writes:

> Signed-off-by: Kristian Høgsberg <krh@redhat.com>
> ---
>  arch/x86/boot/compressed/misc.c |   30 +++++++++++++++++++++++++++---
>  1 files changed, 27 insertions(+), 3 deletions(-)

Isn't that a bit much code to potentially suppress three lines of
output?

	Hannes
