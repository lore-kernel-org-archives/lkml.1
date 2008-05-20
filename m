Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbYETHQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbYETHQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 03:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754462AbYETHQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 03:16:16 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:27850 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbYETHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 03:16:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l5KFF7vsuR4pURnm9H29grwk5JwEh+wR/CdhimAkTci0jmainIxa4U+idV1N0IHftV8ViuVqbbF7JH2T5aUYlH+A2yo9VcE6fwhd7bbNHhcC+kfGvQhHGoVczmZzm/szK9LlUqLmlaAzCrx0hVkrpX4pvVAvEB9EnXTav+9PhE8=
Message-ID: <e2e108260805200016y589fd22eg222980c70a909cf6@mail.gmail.com>
Date: Tue, 20 May 2008 09:16:12 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Jesper Juhl" <trivial@kernel.org>
Subject: Re: [PATCH 2.6.25.1] Suppress more generated files via Documentation/dontdiff
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200805021716.02753.bart.vanassche@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805021716.02753.bart.vanassche@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2008 at 5:16 PM, Bart Van Assche
<bart.vanassche@gmail.com> wrote:
> Can the patch below please be reviewed ? Last time I ran diff over two kernel
> trees I noted that several generated files were included in the diff. The
> patch below suppresses these generated files (modules.order, timeconst.h and
> several vdso* and vdso32* files).

This patch is now obsolete and has been replaced by a new patch -- see
also http://lkml.org/lkml/2008/5/20/32.

Bart.
