Return-Path: <linux-kernel-owner+w=401wt.eu-S1762143AbZDBHCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143AbZDBHCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 03:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755645AbZDBHCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 03:02:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:60199 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbZDBHCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 03:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rLlNn8MqcpzPrrCBFnOV1fUjlKc8LdY5xbH25PsQHPQybm3jm4tdD/vsU/VZeqb+Ck
         kZafGXRGHxMARVqReV6WOBJU6DN3OpTBoE59tNDCQyhrLcppAi0TUGrH5KRWvvjrHreY
         NY+o2QCn64oHitXgdvfD2yyiraeVNZY3S0IcE=
Date: Thu, 2 Apr 2009 16:02:00 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2] Fix highmem build failure
Message-ID: <20090402070200.GB3951@localhost.localdomain>
References: <1238647129-27417-1-git-send-email-galak@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238647129-27417-1-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good. I tested it on x86_32.
