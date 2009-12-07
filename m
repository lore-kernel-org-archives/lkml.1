Return-Path: <linux-kernel-owner+w=401wt.eu-S964961AbZLGSRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961AbZLGSRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935527AbZLGSRu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:17:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935489AbZLGSRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:17:49 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq-iosched: Do not access cfqq after freeing it
References: <20091207181547.GG16900@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Dec 2009 13:17:51 -0500
In-Reply-To: <20091207181547.GG16900@redhat.com> (Vivek Goyal's message of
	"Mon, 7 Dec 2009 13:15:47 -0500")
Message-ID: <x49my1uejhs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Fix a crash during boot reported by Jeff Moyer. Fix the issue of accessing
> cfqq after freeing it.
>
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
